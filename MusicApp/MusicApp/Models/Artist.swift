//
//  Artist.swift
//  MusicApp
//
//  Created by QuanDL.FA on 3/13/23.
//

import Foundation

struct Artists: Codable {

    let external_urls: ExternalUrls?
    let href: String?
    let id: String?
    let name: String?
    let type: String?
    let uri: String?
    let image: [Image]?

}
