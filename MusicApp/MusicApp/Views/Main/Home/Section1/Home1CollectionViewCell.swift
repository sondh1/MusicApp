//
//  Home1CollectionViewCell.swift
//  MusicApp
//
//  Created by QuanDL.FA on 3/17/23.
//

import UIKit
protocol AlbumDelegate {
    func passAlbum(album: String, date: String, artist: String, img: String, url: String, id: String)
}

class Home1CollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var collectionView: UICollectionView!
    
    private var viewModel = HomeViewModel()
    
    var albumDelgate: AlbumDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupView()
        getData()
    }
    
    func setupView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: "Section1CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "Section1CollectionViewCell")
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
                    flowLayout.scrollDirection = .horizontal
                }
        
    }
    
    func getData() {
        viewModel.getData()
        viewModel.delegate = self
    }
    
    func createCell(_ collectionView: UICollectionView, _ indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Section1CollectionViewCell", for: indexPath) as? Section1CollectionViewCell else {
            return UICollectionViewCell()
        }
        let image = viewModel.data3?.albums?.items?[indexPath.row].images?[0].url ?? ""
        let name = viewModel.data3?.albums?.items?[indexPath.row].name ?? ""
        let author = viewModel.data3?.albums?.items?[indexPath.row].artists?[0].name ?? ""
        let totalTracks = String(viewModel.data3?.albums?.items?[indexPath.row].total_tracks ?? 0)
        
        cell.setupCell(img: image, name: name, author: author, totalTracks: totalTracks)
        cell.layer.borderWidth = 0.5
        cell.layer.borderColor = UIColor.black.cgColor
        cell.backgroundColor = .systemGray
        return cell
    }

}

extension Home1CollectionViewCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        HapticsManager.shared.vibrateForSelection()
        let album = viewModel.data3?.albums?.items?[indexPath.row]
        albumDelgate?.passAlbum(album: album?.name ?? "", date: album?.release_date ?? "", artist: album?.artists?[0].name ?? "", img: album?.images?[0].url ?? "", url: album?.external_urls?.spotify ?? "", id: album?.id ?? "")

    }
}

extension Home1CollectionViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.data3?.albums?.items?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        createCell(collectionView, indexPath)
    }
    
    
}

extension Home1CollectionViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width * 9 / 10, height: 129)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
}

extension Home1CollectionViewCell: HomeDelegate {
    func bindData() {
        self.collectionView.reloadData()
    }
}
