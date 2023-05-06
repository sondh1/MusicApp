//
//  SearchResult.swift
//  MusicApp
//
//  Created by QuanDL.FA on 3/30/23.
//

import Foundation

enum SearchResult {
    case artist(model: Artists)
    case album(model: AlbumItems)
    case track(model: AudioTracks)
    case playlist(model: PlaylistItems)
}
