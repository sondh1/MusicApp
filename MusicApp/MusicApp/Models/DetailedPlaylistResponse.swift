//
//  DetailedPlaylistResponse.swift
//  MusicApp
//
//  Created by QuanDL.FA on 3/21/23.
//

import Foundation

struct DetailedPlaylist: Codable {

    let href: String?
    let limit: Int?
    let next: String?
    let offset: Int?
    let previous: String?
    let total: Int?
    let items: [Items]?

}

struct Items: Codable {

    let addedAt: String?
    let addedBy: AddedBy?
    let isLocal: Bool?
    let track: AudioTracks?

}

struct AddedBy: Codable {

    let externalUrls: ExternalUrls?
    let followers: Followers?
    let href: String?
    let id: String?
    let type: String?
    let uri: String?

}


