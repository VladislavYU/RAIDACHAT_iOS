//
//  Chat.swift
//  RaidaChat
//
//  Created by Владислав on 14.12.2017.
//  Copyright © 2017 Владислав. All rights reserved.
//

import Foundation

class Chat {
    let id: Int
    let name: String
    
    var massanges: [[Message]] = []
    
    init(id: Int, name: String) {
        self.id = id
        self.name = name
    }
    
}

