//
//  LibraryViewModel.swift
//  MusicApp
//
//  Created by Đặng Hồng Sơn on 01/05/2023.
//

import Foundation

protocol LibraryPlaylistDelegate {
    func bindingData()
}

protocol LibraryAlbumDelegate {
    func bindingData()
}
class LibraryViewModel {
    var playlistDelegate: LibraryPlaylistDelegate?
    var data1: LibraryPlaylist? {
        didSet {
            playlistDelegate?.bindingData()
        }
    }
    var albumDelegate: LibraryAlbumDelegate?
    var data2: LibraryAlbums? {
        didSet {
            albumDelegate?.bindingData()
        }
    }
    func getData1() {
        NetworkManager.shared.getCurrentUserPlaylists() { [weak self] data in
            guard let self = self else { return }
            self.data1 = data
        }
    }
    func getData2() {
        NetworkManager.shared.getUserSavedAlbum { [weak self] data in
            guard let self = self else { return }
            self.data2 = data
            print(data)
        }
    }
}
