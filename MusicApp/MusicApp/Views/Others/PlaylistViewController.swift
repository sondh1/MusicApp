//
//  PlaylistViewController.swift
//  MusicApp
//
//  Created by QuanDL.FA on 3/15/23.
//

import UIKit
import SDWebImage

class PlaylistViewController: UIViewController {
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var playlistName: UILabel!
    @IBOutlet weak var playlistDesciption: UILabel!
    @IBOutlet weak var playlistAuthor: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var button: UIButton!
    
    var id: String?
    var plName: String?
    var img: String?
    var plAu: String?
    var plDes: String?
    var url: String?
    
    private let viewModel = PlaylistViewModel()

    public var isOwner = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        // Do any additional setup after loading the view.
        self.playlistName.text = plName
        self.playlistAuthor.text = plAu
        self.playlistDesciption.text = plDes
        let urlString = img ?? ""
        let url = URL(string: urlString)
        self.image.sd_setImage(with: url, placeholderImage: UIImage(systemName: "photo"))
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 20
        getData()
        setupView()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(didTapShare))
    }
    
    @objc private func didTapShare() {
        let vc = UIActivityViewController(activityItems: [url ?? ""],
                                          applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }
    
    @IBAction func PlayAll(_ sender: Any) {
        guard let tracks = viewModel.data?.items?.compactMap({ $0.track }) else { return }
        PlaybackPresenter.shared.startPlayback(from: self, tracks: tracks)
    }
    
    func setupView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "PlaylistTableViewCell", bundle: nil), forCellReuseIdentifier: "PlaylistTableViewCell")
    }
    
    func getData() {
        viewModel.playlistID = id
        viewModel.getData()
        viewModel.detaildelegate = self

    }
    
    func createCell(_ tableView: UITableView, _ indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PlaylistTableViewCell",for: indexPath) as? PlaylistTableViewCell else {
            return UITableViewCell()
        }
        let img = viewModel.data?.items?[indexPath.row].track?.album?.images?[0].url ?? ""
        let author = viewModel.data?.items?[indexPath.row].track?.artists?[0].name ?? ""
        let name = viewModel.data?.items?[indexPath.row].track?.name ?? ""
        cell.setupCell(img: img, author: author, name: name)
        
        return cell
    }
    
    
}

extension PlaylistViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        HapticsManager.shared.vibrateForSelection()
        guard let track = viewModel.data?.items?[indexPath.row].track else { return }
        PlaybackPresenter.shared.startPlayback(from: self, track: track)
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if isOwner {
            return true
        }
        return false
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            viewModel.data?.items?.remove(at: indexPath.row)
            tableView.reloadData()
            
        }
    }
        
}

extension PlaylistViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.data?.items?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        createCell(tableView, indexPath)
    }
    
    
}

extension PlaylistViewController: PlaylistDetailDelegate {
    func bindingData() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.tableView.reloadData()
            
        }
        
    }
}


