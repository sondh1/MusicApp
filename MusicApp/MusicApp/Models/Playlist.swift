//
//  Playlist.swift
//  MusicApp
//
//  Created by QuanDL.FA on 3/13/23.
//

import Foundation

struct Playlists: Codable {

    let href: String?
    let limit: Int?
    let next: String?
    let offset: Int?
    let previous: String?
    let total: Int?
    var items: [PlaylistItems]?

}

struct PlaylistItems: Codable {

    let collaborative: Bool?
    let description: String?
    let external_urls: ExternalUrls?
    let href: String?
    let id: String?
    let images: [Image]?
    let name: String?
    let owner: Owner?
    let public_field: Bool?
    let snapshot_id: String?
    let track: AudioTracks?
    let type: String?
    let uri: String?

}
