//
//  UserProfile.swift
//  MusicApp
//
//  Created by QuanDL.FA on 3/13/23.
//

import Foundation

struct UserProfile: Codable {

    let country: String?
    let display_name: String?
    let email: String?
    let explicit_content: ExplicitContent?
    let external_urls: ExternalUrls?
    let followers: Followers?
    let href: String?
    let id: String?
    let images: [Image]?
    let product: String?
    let type: String?
    let uri: String?

}

struct ExplicitContent: Codable {

    let filter_enabled: Bool?
    let filter_locked: Bool?

}

struct ExternalUrls: Codable {

    let spotify: String?

}

struct Followers: Codable {

    let href: String?
    let total: Int?

}

struct Image: Codable {
    let url: String?
    let height: Int?
    let width: Int?
}
