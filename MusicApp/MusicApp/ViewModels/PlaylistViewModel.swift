//
//  PlaylistViewModel.swift
//  MusicApp
//
//  Created by QuanDL.FA on 3/21/23.
//

import Foundation

protocol PlaylistDetailDelegate {
    func bindingData()
}

class PlaylistViewModel {
    var playlistID: String?
    var detaildelegate: PlaylistDetailDelegate?
    var data: Playlists? {
        didSet {
            detaildelegate?.bindingData()
        }
    }
    func getData() {
        NetworkManager.shared.getDetailedPlaylist(id: playlistID ?? "") { [weak self] data1 in
            guard let self = self else { return }
            self.data = data1
            print(data1)
        }
        
    }
}


