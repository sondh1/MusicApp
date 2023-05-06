//
//  RecommendationsResponse.swift
//  MusicApp
//
//  Created by QuanDL.FA on 3/16/23.
//

import Foundation

struct Recommendations: Codable {

    let seeds: [Seeds]?
    let tracks: [AudioTracks]?

}

struct Seeds: Codable {

    let after_filtering_size: Int?
    let after_relinking_size: Int?
    let href: String?
    let id: String?
    let initial_pool_size: Int?
    let type: String?

}



struct Album: Codable {

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

struct LinkedFrom: Codable {

}
