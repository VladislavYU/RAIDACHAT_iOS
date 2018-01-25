//
//  JSON.swift
//  RaidaChat
//
//  Created by Владислав on 23.01.2018.
//  Copyright © 2018 Владислав. All rights reserved.
//

import Foundation

class JSON {
    
    static func getJSONString(_ objcet: [String : Any]) -> String? {
        var str: String?
        do{
            let data = try JSONSerialization.data(withJSONObject: objcet, options: [])
            str = String(data: data, encoding: .utf8)
        } catch {}
        
        return str
    }
    
    static func getJSONData(_ json: [String : Any]) -> Data? {
        var data: Data?
        do{
            data = try JSONSerialization.data(withJSONObject: json, options: [])
        } catch {}
        
        return data
    }
    
    static func getDialogs(data: Data) -> [Dialog]? {
        var dialogs: [Dialog] = []
        do{
            let item = try JSONDecoder().decode(Dialogs.self, from: data)
            dialogs = item.data
        } catch {
            print(error)
        }
        return dialogs
    }
    
    static func getMessages(data: Data) -> [Message]?{
        var messages: [Message] = []
        do{
            let item = try JSONDecoder().decode(Messages.self, from: data)
            messages = item.data
        } catch {
            print(error)
        }
        return messages
    }
    
}
