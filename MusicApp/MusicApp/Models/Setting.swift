//
//  Setting.swift
//  MusicApp
//
//  Created by QuanDL.FA on 3/15/23.
//

import Foundation

struct Section {
    
    let title: String
    let option: [Option]
    
}

struct Option {
    let title: String
    let handler: () -> Void
}
