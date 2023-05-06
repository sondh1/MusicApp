//
//  FeaturePlaylistResponse.swift
//  MusicApp
//
//  Created by QuanDL.FA on 3/16/23.
//

import Foundation

struct FeaturePlaylist: Codable {

    let message: String?
    let playlists: Playlists?

}


struct Owner: Codable {

    let external_urls: ExternalUrls?
    let followers: Followers?
    let href: String?
    let id: String?
    let type: String?
    let uri: String?
    let display_name: String?

}

struct Tracks: Codable {

    let href: String?
    let total: Int?

}
