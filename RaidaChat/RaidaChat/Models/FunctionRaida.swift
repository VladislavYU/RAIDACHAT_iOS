//
//  FunctionRaida.swift
//  RaidaChat
//
//  Created by Владислав on 14.01.2018.
//  Copyright © 2018 Владислав. All rights reserved.
//

import Foundation

struct FunctionRaida: Codable {
    let callFunction: String
    let success: Bool
    let msgError: String
//    let data: Data
}

enum CalledFunc: String {
    case autorization = "authorization"
    case registration = "registration"
    case createGroup = "createGroup"
    case addMemberInGroup = "addMemberInGroup"
    case sendMsg = "sendMsg"
    case newMsg = "newMsg"
    case getMsg = "getMsg"
    case getMyDialogs = "getMyDialogs"
}

