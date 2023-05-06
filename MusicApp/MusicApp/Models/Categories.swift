//
//  Categories.swift
//  MusicApp
//
//  Created by QuanDL.FA on 3/29/23.
//

import Foundation

struct CategoryResponse: Codable {

    let categories: Categories?

}

struct Categories: Codable {

    let href: String?
    let limit: Int?
    let next: String?
    let offset: Int?
    let previous: String?
    let total: Int?
    let items: [CategoryItems]?

}

struct CategoryItems: Codable {

    let href: String?
    let icons: [Image]?
    let id: String?
    let name: String?

}

struct CategoryPlaylist: Codable {
    
    let playlists: Playlists?
    
}


