//
//  Chat.swift
//  RaidaChat
//
//  Created by Владислав on 14.12.2017.
//  Copyright © 2017 Владислав. All rights reserved.
//

import Foundation

struct Dialog: Codable {
    let id: String
    let name: String
    let group: Bool
}

struct Dialogs: Codable {
    let data: [Dialog]
//    
//    enum CodingsKeys: String, CodingKey {
//        case dialogs = "data"
//    }
}
