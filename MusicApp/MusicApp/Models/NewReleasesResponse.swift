//
//  NewReleasesResponse.swift
//  MusicApp
//
//  Created by QuanDL.FA on 3/16/23.
//

import Foundation

struct NewReleases: Codable {

    let albums: Albums?

}

struct Albums: Codable {

    let href: String?
    let limit: Int?
    let next: String?
    let offset: Int?
    let previous: String?
    let total: Int?
    var items: [AlbumItems]?

}

struct AlbumItems: Codable {

    let album_type: String?
    let total_tracks: Int?
    let available_markets: [String]?
    let external_urls: ExternalUrls?
    let href: String?
    let id: String?
    let images: [Image]?
    let name: String?
    let release_date: String?
    let release_date_precision: String?
    let restrictions: Restrictions?
    let type: String?
    let uri: String?
    let copyrights: [Copyrights]?
    let external_ids: ExternalIds?
    let genres: [String]?
    let label: String?
    let popularity: Int?
    let album_group: String?
    let artists: [Artists]?

}


struct Restrictions: Codable {

    let reason: String?

}

struct Copyrights: Codable {

    let text: String?
    let type: String?

}

struct ExternalIds: Codable {

    let isrc: String?
    let ean: String?
    let upc: String?

}


