//
//  LibraryViewController.swift
//  MusicApp
//
//  Created by QuanDL.FA on 3/13/23.
//

import UIKit

class LibraryViewController: UIViewController {

    private let playlistVC = LibraryPlaylistViewController()
    private let albumVC = LibraryAlbumViewController()

    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isPagingEnabled = true
        return scrollView
    }()
    
    private let toggleView = LibraryChoice()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.addSubview(toggleView)
        toggleView.delegate = self
        scrollView.delegate = self
        scrollView.isScrollEnabled = false
        view.addSubview(scrollView)
        scrollView.contentSize = CGSize(width: view.bounds.width*2, height: scrollView.bounds.height)
        addChildren()
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .done, target: self, action: #selector(didTapAdd))
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.frame = CGRect(x: 0, y: view.safeAreaInsets.top+55, width: view.bounds.width, height: view.bounds.height-view.safeAreaInsets.top-view.safeAreaInsets.bottom-55)
        toggleView.frame = CGRect(x: 0, y: view.safeAreaInsets.top, width: 200, height: 55)
    }
    private func addChildren() {
        addChild(playlistVC)
        scrollView.addSubview(playlistVC.view)
        playlistVC.view.frame = CGRect(x: 0, y: 0, width: scrollView.bounds.width, height: scrollView.bounds.height)
        playlistVC.didMove(toParent: self)
        
        addChild(albumVC)
        scrollView.addSubview(albumVC.view)
        albumVC.view.frame = CGRect(x: view.bounds.width, y: 0, width: scrollView.bounds.width, height: scrollView.bounds.height)
        albumVC.didMove(toParent: self)
    }
    @objc func didTapAdd() {
        let alert = UIAlertController(title: "New Playlist", message: "Enter playlist name", preferredStyle: .alert)
        alert.addTextField { textfield in
            textfield.placeholder = "Playlist..."
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Create", style: .default, handler: { _ in
            guard let field = alert.textFields?.first, let text = field.text, !text.trimmingCharacters(in: .whitespaces).isEmpty else {
                return
            }
            NetworkManager.shared.createPlaylist(with: text) { success in
                if success {
                    
                } else {
                    print("Fail to create playlist")
                }
            }
            
        }))
        present(alert, animated: true)
    }

}
extension LibraryViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x >= (view.bounds.width-100) {
            toggleView.update(for: .album)
        } else {
            toggleView.update(for: .playlist)
        }
    }
}
extension LibraryViewController: LibraryChoiceDelegate {
    func didTapPlaylist(_ toggleView: LibraryChoice) {
        scrollView.setContentOffset(.zero, animated: true)
    }
    
    func didTapAlbum(_ toggleView: LibraryChoice) {
        scrollView.setContentOffset(CGPoint(x: view.bounds.width, y: 0), animated: true)
    }
    
    
}
