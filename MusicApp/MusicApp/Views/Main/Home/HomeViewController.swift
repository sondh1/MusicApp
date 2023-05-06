//
//  HomeViewController.swift
//  MusicApp
//
//  Created by QuanDL.FA on 3/16/23.
//

import UIKit
import SDWebImage

class HomeViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private let viewModel = HomeViewModel()
    private var tracks = [AudioTracks]()
    
    let headerTitle = ["Các album mới ra mắt", "Các playlist được nghe nhiều nhất", "Các bàì hát bạn có thể thích" ]
    var playlistImage: UIImageView?
    var playlistName: String?
    var playlistAuthor: String?
    var playlistDesciption: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Home"
        // Do any additional setup after loading the view.
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gear"), style: .done, target: self, action: #selector(didTapSetting))
        getData()
        setupView()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
    func getData() {
        viewModel.getData()
        viewModel.delegate = self
        
    }
    
   
    
    func setupView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "Home1CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "Home1CollectionViewCell")
        collectionView.register(UINib(nibName: "Home2CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "Home2CollectionViewCell")
        collectionView.register(UINib(nibName: "Home3CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "Home3CollectionViewCell")
        collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HeaderView")
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.scrollDirection = .vertical
        }
        
    }
    
    
    func createCell(_ collectionView: UICollectionView, _ indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 0 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Home1CollectionViewCell",for: indexPath) as? Home1CollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.albumDelgate = self
            return cell
            
        }
        
        else if indexPath.row == 1 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Home2CollectionViewCell",for: indexPath) as? Home2CollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.playlistDelegate = self
            return cell
        }
        
        else if indexPath.row == 2 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Home3CollectionViewCell",for: indexPath) as? Home3CollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.trackdelegate = self
            return cell
        }
        else {
            return UICollectionViewCell()
        }
        
        
    }
    
    @objc func didTapSetting() {
        let vc = SettingViewController()
        vc.title = "Setting"
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
}

extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
}

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        createCell(collectionView, indexPath)
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "HeaderView", for: indexPath)
            headerView.backgroundColor = .white
            let label = UILabel(frame: headerView.bounds)
            label.text = headerTitle[indexPath.section]
            label.textColor = .black
            headerView.addSubview(label)
            return headerView
        } else {
            return UICollectionReusableView()
        }
    }
    
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.row == 0 {
            return CGSize(width: collectionView.bounds.width, height: 390)
        }
        else if indexPath.row == 1 {
            return CGSize(width: collectionView.bounds.width, height: 500)
        }
        else if indexPath.row == 2 {
            return CGSize(width: collectionView.bounds.width, height: 300)
        }
        else {
            return CGSize(width: 0, height: 0)
        }
    }
}

extension HomeViewController: AlbumDelegate {
    func passAlbum(album: String, date: String, artist: String, img: String, url: String, id: String) {
        let vc = AlbumViewController()
        vc.title = album
        vc.navigationItem.largeTitleDisplayMode = .never
        vc.id = id
        vc.name = album
        vc.url = url
        vc.des = date
        vc.owner = artist
        vc.image = img
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension HomeViewController: PlaylistDelegate {
    func passPlaylist(name: String, id: String, img: String, author: String, descriptions: String, url: String) {
        let vc = PlaylistViewController()
        vc.title = name
        vc.id = id
        vc.plName = name
        vc.plAu = author
        vc.plDes = descriptions
        vc.img = img
        vc.url = url
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension HomeViewController: TrackDelegate {
    func passTrack(track: AudioTracks) {
        PlaybackPresenter.shared.startPlayback(from: self, track: track)
    }
    func longPress(tracks: AudioTracks) {
        let actionSheet = UIAlertController(title: tracks.name, message: "Would you like to add this to playlist", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        actionSheet.addAction(UIAlertAction(title: "Add to Playlist", style: .default, handler: { [weak self] _ in
            DispatchQueue.main.async {
                let vc = LibraryPlaylistViewController()
                vc.selectionHandler = { playlist in
                    NetworkManager.shared.addTrackToPlaylist(track: tracks, playlist: playlist) { success in
                        print("success\(success)")
                    }
                }
                vc.title = "Select Playlist"
                self?.present(UINavigationController(rootViewController: vc), animated: true)
            }
        }))
        present(actionSheet,animated: true)
    }
}

extension HomeViewController: HomeDelegate {
    func bindData() {
        
    }
}
