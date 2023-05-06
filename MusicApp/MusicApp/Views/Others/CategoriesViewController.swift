//
//  CategoriesViewController.swift
//  MusicApp
//
//  Created by QuanDL.FA on 3/30/23.
//

import UIKit



class CategoriesViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    private var viewModel = CategoryViewModel()
    
    var id: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
        setupView()
    }
    
    func setupView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "CategoryCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CategoryCollectionViewCell")
        
    }
    
    func getData() {
        viewModel.categoryid = id
        viewModel.getDetail()
        viewModel.categorydelegate = self
        
    }
    
    func createCell(_ collectionView: UICollectionView, _ indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCollectionViewCell", for: indexPath) as? CategoryCollectionViewCell else {
            return UICollectionViewCell()
        }
        let image = viewModel.data1?.playlists?.items?[indexPath.row].images?[0].url ?? ""
        let name = viewModel.data1?.playlists?.items?[indexPath.row].name ?? ""
        cell.setupCell(image: image, name: name)
        return cell
    }


}
extension CategoriesViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        HapticsManager.shared.vibrateForSelection()
        let vc = PlaylistViewController()
        vc.title = viewModel.data1?.playlists?.items?[indexPath.row].name
        vc.id = viewModel.data1?.playlists?.items?[indexPath.row].id
        vc.plName = viewModel.data1?.playlists?.items?[indexPath.row].name
        vc.plAu = viewModel.data1?.playlists?.items?[indexPath.row].owner?.display_name
        vc.plDes = viewModel.data1?.playlists?.items?[indexPath.row].description
        vc.img = viewModel.data1?.playlists?.items?[indexPath.row].images?[0].url
        vc.url = viewModel.data1?.playlists?.items?[indexPath.row].external_urls?.spotify
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension CategoriesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.data1?.playlists?.items?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        createCell(collectionView, indexPath)
    }
    
    
}

extension CategoriesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 150, height: 250)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 15, bottom: 0, right: 15)
    }
}

extension CategoriesViewController: CategoryDelegate {
    func bindingData() {
        self.collectionView.reloadData()
    }
}
