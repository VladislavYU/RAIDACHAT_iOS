//
//  User.swift
//  RaidaChat
//
//  Created by Владислав on 18.12.2017.
//  Copyright © 2017 Владислав. All rights reserved.
//

import Foundation

class User {
    let login: String!
    let password: String!
    
    init(login: String, password: String) {
        self.login = login
        self.password = password
    }
}
