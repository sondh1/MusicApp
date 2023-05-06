//
//  Home2CollectionViewCell.swift
//  MusicApp
//
//  Created by QuanDL.FA on 3/17/23.
//

import UIKit

protocol PlaylistDelegate {
    func passPlaylist(name: String, id: String, img: String, author: String, descriptions: String, url: String)
}

class Home2CollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var playlistDelegate: PlaylistDelegate?
    
    private var viewModel = HomeViewModel()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

        setupView()
        getData()
    }
    
    func setupView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: "Section2CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "Section2CollectionViewCell")
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
                    flowLayout.scrollDirection = .horizontal
                }
        
    }
    
    func getData() {
        viewModel.getData()
        viewModel.delegate = self
    }
    
    func createCell(_ collectionView: UICollectionView, _ indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Section2CollectionViewCell", for: indexPath) as? Section2CollectionViewCell else {
            return UICollectionViewCell()
        }
        let image = viewModel.data2?.playlists?.items?[indexPath.row].images?[0].url ?? ""
        let name = viewModel.data2?.playlists?.items?[indexPath.row].name ?? ""
        let author = viewModel.data2?.playlists?.items?[indexPath.row].owner?.display_name ?? ""
        cell.setupCell(image: image, name: name, author: author)
        return cell
    }

}

extension Home2CollectionViewCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        HapticsManager.shared.vibrateForSelection()
        let playlist = viewModel.data2?.playlists?.items?[indexPath.row]
        playlistDelegate?.passPlaylist(name: playlist?.name ?? "", id: playlist?.id ?? "", img: playlist?.images?[0].url ?? "", author: playlist?.owner?.display_name ?? "", descriptions: playlist?.description ?? "", url: playlist?.external_urls?.spotify ?? "")
        
    }
}

extension Home2CollectionViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.data2?.playlists?.items?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        createCell(collectionView, indexPath)
    }
    
    
}

extension Home2CollectionViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 250, height: 249)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }

}

extension Home2CollectionViewCell: HomeDelegate {
    func bindData() {
        self.collectionView.reloadData()
    }
}
