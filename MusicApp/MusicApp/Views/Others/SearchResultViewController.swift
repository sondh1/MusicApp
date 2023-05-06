//
//  SearchResultViewController.swift
//  MusicApp
//
//  Created by QuanDL.FA on 3/15/23.
//

import UIKit

struct SearchSection {
    let title: String
    let results: [SearchResult]
}

protocol SearchResultDelegate {
    func showResult(_ controller: UIViewController)
}

class SearchResultViewController: UIViewController {

    var delegate: SearchResultDelegate?
    
    private var sections: [SearchSection] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .clear
        setupView()
    }
    
    func setupView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "SearchResultTableViewCell", bundle: nil), forCellReuseIdentifier: "SearchResultTableViewCell")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    func update(with results: [SearchResult]) {
        let artists = results.filter({
            switch $0 {
            case .artist: return true
            default: return false
            }
        })
        let albums = results.filter({
            switch $0 {
            case .album: return true
            default: return false
            }
        })
        let tracks = results.filter({
            switch $0 {
            case .track: return true
            default: return false
            }
        })
        let playlists = results.filter({
            switch $0 {
            case .playlist: return true
            default: return false
            }
        })
        self.sections = [SearchSection(title: "Artists", results: artists),
                         SearchSection(title: "Albums", results: albums),
                         SearchSection(title: "Tracks", results: tracks),
                         SearchSection(title: "Playlists", results: playlists)
        ]
        tableView.reloadData()
        tableView.isHidden = results.isEmpty
    }
    
    func createCell(_ tableView: UITableView, _ indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SearchResultTableViewCell",for: indexPath) as? SearchResultTableViewCell else {
            return UITableViewCell()
        }
        let result = sections[indexPath.section].results[indexPath.row]
        switch result {
        case .artist(let model):
            cell.setupCell(name: model.name ?? "", author: "", image: model.image?[0].url ?? "")
        case .album(model: let model):
            cell.setupCell(name: model.name ?? "", author: model.artists?[0].name ?? "", image: model.images?[0].url ?? "")
        case .track(model: let model):
            cell.setupCell(name: model.name ?? "", author: model.artists?[0].name ?? "", image: model.album?.images?[0].url ?? "")
        case .playlist(model: let model):
            cell.setupCell(name: model.name ?? "", author: model.owner?.display_name ?? "", image: model.images?[0].url ?? "")
        }
        return cell
    }

}

extension SearchResultViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        HapticsManager.shared.vibrateForSelection()
        let result = sections[indexPath.section].results[indexPath.row]
        switch result {
        case .artist(let model):
            break
        case .album(model: let model):
            let vc = AlbumViewController()
            vc.id = model.id
            vc.image = model.images?[0].url
            vc.name = model.name
            vc.owner = model.artists?[0].name
            vc.des = model.release_date
            delegate?.showResult(vc)
            vc.navigationItem.largeTitleDisplayMode = .never
        case .track(model: let model):
            PlaybackPresenter.shared.startPlayback(from: self, track: model)
        case .playlist(model: let model):
            let vc = PlaylistViewController()
            vc.id = model.id
            vc.img = model.images?[0].url
            vc.plAu = model.owner?.display_name
            vc.plName = model.name
            vc.plDes = model.description
            delegate?.showResult(vc)
            vc.navigationItem.largeTitleDisplayMode = .never

        }
    }
}

extension SearchResultViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sections[section].results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        createCell(tableView, indexPath)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].title
    }
    
}
