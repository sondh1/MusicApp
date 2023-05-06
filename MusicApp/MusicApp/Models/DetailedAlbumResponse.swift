//
//  DetailedAlbumResponse.swift
//  MusicApp
//
//  Created by QuanDL.FA on 3/22/23.
//

import Foundation

struct DetailedAlbum: Codable {

    let albumType: String?
    let totalTracks: Int?
    let availableMarkets: [String]?
    let externalUrls: ExternalUrls?
    let href: String?
    let id: String?
    let images: [Image]?
    let name: String?
    let releaseDate: String?
    let releaseDatePrecision: String?
    let restrictions: Restrictions?
    let type: String?
    let uri: String?
    let copyrights: [Copyrights]?
    let externalIds: ExternalIds?
    let genres: [String]?
    let label: String?
    let popularity: Int?
    let artists: [Artists]?
    let tracks: AlbumTracks?

}

struct AlbumTracks: Codable {

    let href: String?
    let limit: Int?
    let next: String?
    let offset: Int?
    let previous: String?
    let total: Int?
    let items: [AudioTracks]?

}

