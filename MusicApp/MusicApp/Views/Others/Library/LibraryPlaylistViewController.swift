//
//  LibraryPlaylistViewController.swift
//  MusicApp
//
//  Created by Đặng Hồng Sơn on 01/05/2023.
//

import UIKit

class LibraryPlaylistViewController: UIViewController {

    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(UINib(nibName: "SearchResultTableViewCell", bundle: nil), forCellReuseIdentifier: "SearchResultTableViewCell")
        tableView.isHidden = true
        return tableView
    }()
    private var viewModel = LibraryViewModel()
    
    private let noPlaylistView = ActionLabelView()
    
    public var selectionHandler: ((PlaylistItems) -> Void)?
    
    private let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getData()
        noPlaylistView.configure(with: ActionLabelViewViewModel(text: "You don't have any playlist yet", actionTitle: "Create"))
        view.addSubview(tableView)
        view.addSubview(noPlaylistView)
        noPlaylistView.delegate = self
        setupView()
        updateUI()
        if selectionHandler != nil {
            navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(didTapClose))
        }
        if #available(iOS 10.0, *) {
            self.tableView.refreshControl = refreshControl
        } else {
            self.tableView.addSubview(refreshControl)
        }
        self.refreshControl.addTarget(self, action: #selector(updateUI), for: .valueChanged)
    }
    @objc func didTapClose() {
        dismiss(animated: true)
    }
    
    func getData() {
        viewModel.getData1()
        viewModel.playlistDelegate = self
    }
    func setupView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        noPlaylistView.frame = CGRect(x: 0, y: 0, width: 150, height: 150)
        noPlaylistView.center = view.center
        tableView.frame = view.bounds
    }
    
    func createCell(_ tableView: UITableView, _ indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SearchResultTableViewCell",for: indexPath) as? SearchResultTableViewCell else {
            return UITableViewCell()
        }
        let img = viewModel.data1?.items[indexPath.row].images?.first?.url ?? ""
        let author = viewModel.data1?.items[indexPath.row].owner?.display_name ?? ""
        let name = viewModel.data1?.items[indexPath.row].name ?? ""
        cell.setupCell(name: name, author: author, image: img)
        
        return cell
    }
    
    @objc func updateUI() {
        if viewModel.data1?.items.count == 0 {
            noPlaylistView.isHidden = false
            tableView.isHidden = true
        } else {
            tableView.reloadData()
            noPlaylistView.isHidden = true
            tableView.isHidden = false
            self.refreshControl.endRefreshing()
        }
    }

}
extension LibraryPlaylistViewController: LibraryPlaylistDelegate {
    func bindingData() {
        self.tableView.reloadData()
    }
}
extension LibraryPlaylistViewController: ActionLabelViewDeleggate {
    func actionLabelViewDidTapButton(_ actionView: ActionLabelView) {
        let alert = UIAlertController(title: "New Playlist", message: "Enter playlist name", preferredStyle: .alert)
        alert.addTextField { textfield in
            textfield.placeholder = "Playlist..."
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Create", style: .default, handler: { _ in
            guard let field = alert.textFields?.first, let text = field.text, !text.trimmingCharacters(in: .whitespaces).isEmpty else {
                return
            }
            NetworkManager.shared.createPlaylist(with: text) { success in
                if success {
                    self.tableView.reloadData()
                } else {
                    print("Fail to create playlist")
                }
            }
            
        }))
        present(alert, animated: true)
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            viewModel.data1?.items.remove(at: indexPath.row)
            tableView.reloadData()
        }
    }
    
    
}

extension LibraryPlaylistViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        HapticsManager.shared.vibrateForSelection()
        let playlist = viewModel.data1?.items[indexPath.row]
        guard selectionHandler == nil else {
            selectionHandler?(playlist!)
            dismiss(animated: true, completion: nil)
            return
        }
        let vc = PlaylistViewController()
        vc.id = playlist?.id
        vc.img = playlist?.images?.first?.url
        vc.plName = playlist?.name
        vc.plDes = playlist?.description
        vc.plAu = playlist?.owner?.display_name
        vc.url = playlist?.external_urls?.spotify
        vc.navigationItem.largeTitleDisplayMode = .never
        vc.isOwner = true
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension LibraryPlaylistViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.data1?.items.count ?? 0 - 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        createCell(tableView, indexPath)
    }
    
    
}
