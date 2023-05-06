//
//  AlbumViewModel.swift
//  MusicApp
//
//  Created by QuanDL.FA on 3/21/23.
//

import Foundation

protocol AlbumDetailDelegate {
    func bindingData()
}

class AlbumViewModel {
    var albumID: String?
    var detaildelegate: AlbumDetailDelegate?
        var data: DetailedAlbum? {
            didSet {
                detaildelegate?.bindingData()
            }
        }
    func getData() {
            NetworkManager.shared.getAlbumDetail(id: albumID ?? "") { [weak self] data1 in
                guard let self = self else { return }
                self.data = data1
            }
    }
}
