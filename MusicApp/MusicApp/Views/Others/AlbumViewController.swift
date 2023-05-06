//
//  AlbumViewController.swift
//  MusicApp
//
//  Created by QuanDL.FA on 3/21/23.
//

import UIKit

class AlbumViewController: UIViewController {

    private let viewModel = AlbumViewModel()

    private var tracks = [AudioTracks]()
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var ownerLbl: UILabel!
    @IBOutlet weak var descriptLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var button: UIButton!
    
    var id: String?
    var image: String?
    var url: String?
    var owner: String?
    var name: String?
    var des: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.ownerLbl.text = owner
        self.descriptLbl.text = des
        self.nameLbl.text = name
        let urlString = image ?? ""
        let url = URL(string: urlString)
        self.img.sd_setImage(with: url, placeholderImage: UIImage(systemName: "photo"))
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 20
        getData()
        setupView()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(didTapShare))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(didTapAction))
    }
    @objc func didTapAction() {
        let actionSheet = UIAlertController(title: viewModel.data?.name, message: "Action", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        actionSheet.addAction(UIAlertAction(title: "Save Album", style: .default, handler: { _ in
            NetworkManager.shared.saveAlbum(album: self.viewModel.data!) { success in
                print("Saved: \(success)")
            }
        }))
        present(actionSheet, animated: true)
    }
    
    @objc private func didTapShare() {
        let vc = UIActivityViewController(activityItems: [url ?? ""],
                                          applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }
    
    @IBAction func PlayAll(_ sender: Any) {
        PlaybackPresenter.shared.startPlayback(from: self, tracks: tracks)
    }
    
    func setupView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "AlbumTableViewCell", bundle: nil), forCellReuseIdentifier: "AlbumTableViewCell")
    }
    
    func getData() {
        viewModel.albumID = id
        viewModel.getData()
        viewModel.detaildelegate = self
    }
    
    func createCell(_ tableView: UITableView, _ indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AlbumTableViewCell",for: indexPath) as? AlbumTableViewCell else {
            return UITableViewCell()
        }

        let author = viewModel.data?.tracks?.items?[indexPath.row].artists?[0].name ?? ""
        let name = viewModel.data?.tracks?.items?[indexPath.row].name ?? ""
        cell.setupCell(author: author, name: name)
        
        return cell
    }
    
    
}

extension AlbumViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        HapticsManager.shared.vibrateForSelection()
        guard let items = viewModel.data?.tracks?.items else { return }
        self.tracks = items
        let track = tracks[indexPath.row]
        PlaybackPresenter.shared.startPlayback(from: self, track: track)
    }
}

extension AlbumViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.data?.tracks?.items?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        createCell(tableView, indexPath)
    }
    
    
}

extension AlbumViewController: AlbumDetailDelegate {
    func bindingData() {
        self.tableView.reloadData()
    }
    
}

