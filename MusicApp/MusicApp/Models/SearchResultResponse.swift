//
//  SearchResultResponse.swift
//  MusicApp
//
//  Created by QuanDL.FA on 3/30/23.
//

import Foundation

struct SearchResultResponse: Codable {
    let albums: SearchAlbumResponse
    let playlists: SearchPlaylistResponse
    let artists: SearchArtistResponse
    let tracks: SearchTrackResponse
    
}

struct SearchAlbumResponse: Codable {
    
    let items: [AlbumItems]
    
}

struct SearchPlaylistResponse: Codable {
    
    let items: [PlaylistItems]
    
}

struct SearchArtistResponse: Codable {
    
    let items: [Artists]
    
}

struct SearchTrackResponse: Codable {
    
    let items: [AudioTracks]
    
}
