//
//  Message.swift
//  RaidaChat
//
//  Created by Владислав on 14.12.2017.
//  Copyright © 2017 Владислав. All rights reserved.
//

import Foundation

struct Message: Codable{
    let guidMsg: String
    var textMsg: String
    let sender: String
    let group: String
    let recipient: String
    let sendTime: CLong
    let curFrg: Int
    let totalFrg: Int
    let senderName: String
    let groupName: String
}

struct SendMessage: Codable {
    let recipientId: String
    let recipientLogin: String
    let toGroup: Bool
    let textMsg: String
    let guidMsg: String
    let sendTime: CLong
    let curFrg: Int
    let totalFrg: Int
}

struct Messages: Codable {
    let data: [Message]
}
