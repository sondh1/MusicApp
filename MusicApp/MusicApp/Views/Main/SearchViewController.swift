//
//  SearchViewController.swift
//  MusicApp
//
//  Created by QuanDL.FA on 3/28/23.
//

import UIKit

class SearchViewController: UIViewController {

    let searchController: UISearchController = {
        let vc = UISearchController(searchResultsController: SearchResultViewController())
        vc.searchBar.placeholder = "Songs, Artists, Albums"
        vc.searchBar.searchBarStyle = .minimal
        vc.definesPresentationContext = true
        return vc
    }()
    
    private let colors: [UIColor] = [
        .systemPink,
        .systemBlue,
        .systemRed,
        .systemCyan,
        .systemGray,
        .systemBrown,
        .systemYellow,
        .systemGreen,
        .systemTeal
    ]
    
    private let viewModel = CategoryViewModel()

    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
        
        getData()
        setupView()
    }
    
    func setupView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "SearchCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "SearchCollectionViewCell")
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.scrollDirection = .vertical
        }
    }
    
    func getData() {
        viewModel.getData()
        viewModel.categorydelegate = self
    }

    func createCell(_ collectionView: UICollectionView, _ indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchCollectionViewCell", for: indexPath) as? SearchCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.setupCell(name: "ABC", image: "abc")
        cell.layer.masksToBounds = true
        cell.layer.cornerRadius = 8
        cell.backgroundColor = colors.randomElement()
        let name = viewModel.data?.categories?.items?[indexPath.row].name ?? ""
        let image = viewModel.data?.categories?.items?[indexPath.row].icons?[0].url ?? ""
        cell.setupCell(name: name, image: image)
        return cell
    }
    

    


}

extension SearchViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        HapticsManager.shared.vibrateForSelection()
        let vc = CategoriesViewController()
        vc.id = viewModel.data?.categories?.items?[indexPath.row].id ?? ""
        vc.title = "Playlists"
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension SearchViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        createCell(collectionView, indexPath)
    }
    
    
}
extension SearchViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width / 7 * 3, height: collectionView.bounds.height / 4)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 10, bottom: 0, right: 10)
    }
    
}

extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {


    }
}

extension SearchViewController: CategoryDelegate {
    func bindingData() {
        self.collectionView.reloadData()
    }
    
    
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let resultsController = searchController.searchResultsController as? SearchResultViewController,
              let query = searchBar.text,
              !query.trimmingCharacters(in: .whitespaces).isEmpty else {
            return
        }
        resultsController.delegate = self
        NetworkManager.shared.getSearch(query: query) { result in
            var searchResult: [SearchResult] = []
            searchResult.append(contentsOf: result.tracks.items.compactMap({ .track(model: $0)}))
            searchResult.append(contentsOf: result.albums.items.compactMap({ .album(model: $0)}))
            searchResult.append(contentsOf: result.artists.items.compactMap({ .artist(model: $0)}))
            searchResult.append(contentsOf: result.playlists.items.compactMap({ .playlist(model: $0)}))
            resultsController.update(with: searchResult)
        }
    }
}

extension SearchViewController: SearchResultDelegate {
    func showResult(_ controller: UIViewController) {
        navigationController?.pushViewController(controller, animated: true)
    }
    
    
}

