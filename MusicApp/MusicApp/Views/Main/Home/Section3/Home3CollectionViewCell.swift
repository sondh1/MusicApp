//
//  Home2CollectionViewCell.swift
//  MusicApp
//
//  Created by QuanDL.FA on 3/17/23.
//

import UIKit
protocol TrackDelegate {
    func passTrack(track: AudioTracks)
    func longPress(tracks: AudioTracks)
}

class Home3CollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var collectionView: UICollectionView!
    
    private var viewModel = HomeViewModel()
    
    var trackdelegate: TrackDelegate?

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupView()
        getData()
        addLongTapGesture()
    }
    
    private func addLongTapGesture() {
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(didLongPress(_:)))
        collectionView.isUserInteractionEnabled = true
        collectionView.addGestureRecognizer(gesture)
    }
    @objc func didLongPress(_ gesture: UILongPressGestureRecognizer) {
        guard gesture.state == .began else {
            return
        }
        
        let touch = gesture.location(in: collectionView)
        
        guard let indexPath = collectionView.indexPathForItem(at: touch) else {
            return
        }
        guard let model = viewModel.data1?.tracks?[indexPath.row] else { return }
        trackdelegate?.longPress(tracks: model)
        
    }
    
    func setupView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: "Section3CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "Section3CollectionViewCell")
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
                    flowLayout.scrollDirection = .vertical
                }
        
    }
    
    func getData() {
        viewModel.getData()
        viewModel.delegate = self
    }
    
    func createCell(_ collectionView: UICollectionView, _ indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Section3CollectionViewCell", for: indexPath) as? Section3CollectionViewCell else {
            return UICollectionViewCell()
        }
        let image = viewModel.data1?.tracks?[indexPath.row].album?.images?[0].url ?? ""
        let name = viewModel.data1?.tracks?[indexPath.row].name ?? ""
        let author = viewModel.data1?.tracks?[indexPath.row].artists?[0].name ?? ""
        cell.setupCell(image: image, name: name, author: author)
        return cell
    }

}

extension Home3CollectionViewCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        HapticsManager.shared.vibrateForSelection()
        guard let track = viewModel.data1?.tracks?[indexPath.row] else { return }
        trackdelegate?.passTrack(track: track)
    }
}

extension Home3CollectionViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.data1?.tracks?.count ?? 0
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        createCell(collectionView, indexPath)
    }
    
    
}

extension Home3CollectionViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 60)
    }
}

extension Home3CollectionViewCell: HomeDelegate {
    func bindData() {
        self.collectionView.reloadData()
    }
}
