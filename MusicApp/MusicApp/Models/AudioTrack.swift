//
//  AudioTrack.swift
//  MusicApp
//
//  Created by QuanDL.FA on 3/13/23.
//

import Foundation

struct AudioTracks: Codable {

    let album: Album?
    let artists: [Artists]?
    let available_markets: [String]?
    let disc_number: Int?
    let duration_ms: Int?
    let explicit: Bool?
    let external_ids: ExternalIds?
    let external_urls: ExternalUrls?
    let href: String?
    let id: String?
    let is_playable: Bool?
    let linked_from: LinkedFrom?
    let restrictions: Restrictions?
    let name: String?
    let popularity: Int?
    let preview_url: String?
    let track_number: Int?
    let type: String?
    let uri: String?
    let is_local: Bool?

}
