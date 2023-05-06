//
//  LibraryAlbumViewController.swift
//  MusicApp
//
//  Created by Đặng Hồng Sơn on 01/05/2023.
//

import UIKit

class LibraryAlbumViewController: UIViewController {

    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(UINib(nibName: "SearchResultTableViewCell", bundle: nil), forCellReuseIdentifier: "SearchResultTableViewCell")
        tableView.isHidden = true
        return tableView
    }()

    private var viewModel = LibraryViewModel()
    
    private let noAlbumView = ActionLabelView()
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getData()
        noAlbumView.configure(with: ActionLabelViewViewModel(text: "You don't have any album yet", actionTitle: "Browse"))
        view.addSubview(noAlbumView)
        noAlbumView.delegate = self
        setupView()
        updateUI()
        
    }
    
    @objc func didTapClose() {
        dismiss(animated: true)
    }
    
    func getData() {
        viewModel.getData2()
        viewModel.albumDelegate = self
    }
    func setupView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        noAlbumView.frame = CGRect(x: (view.bounds.width-150)/2, y: (view.bounds.height-150)/2, width: 150, height: 150)
        tableView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
        
    }
    
    func createCell(_ tableView: UITableView, _ indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SearchResultTableViewCell",for: indexPath) as? SearchResultTableViewCell else {
            return UITableViewCell()
        }
        let img = viewModel.data2?.albums.items?[indexPath.row].images?.first?.url ?? ""
        let author = viewModel.data2?.albums.items?[indexPath.row].artists?.first?.name ?? ""
        let name = viewModel.data2?.albums.items?[indexPath.row].name ?? ""
        cell.setupCell(name: name, author: author, image: img)
        
        return cell
    }
    
    private func updateUI() {
        if viewModel.data2?.albums.items?.count == 0 {
            noAlbumView.isHidden = false
            tableView.isHidden = true
        } else {
            tableView.reloadData()
            noAlbumView.isHidden = true
            tableView.isHidden = false
        }
    }

}
extension LibraryAlbumViewController: LibraryAlbumDelegate {
    func bindingData() {
        self.tableView.reloadData()
        updateUI()
    }
}
extension LibraryAlbumViewController: ActionLabelViewDeleggate {
    func actionLabelViewDidTapButton(_ actionView: ActionLabelView) {
        tabBarController?.selectedIndex = 0
    }
    
    
}

extension LibraryAlbumViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        HapticsManager.shared.vibrateForSelection()
        let album = viewModel.data2?.albums.items?[indexPath.row]
        let vc = AlbumViewController()
        vc.navigationItem.largeTitleDisplayMode = .never
        vc.id = album?.id
        vc.name = album?.name
        vc.url = album?.external_urls?.spotify
        vc.des = album?.release_date
        vc.owner = album?.artists?.first?.name
        vc.image = album?.images?.first?.url
        navigationController?.pushViewController(vc, animated: true)
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            viewModel.data2?.albums.items?.remove(at: indexPath.row)

            tableView.reloadData()
        }
    }
}

extension LibraryAlbumViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.data2?.albums.items?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        createCell(tableView, indexPath)
    }
    
    
}
