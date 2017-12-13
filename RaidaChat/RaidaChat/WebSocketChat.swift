//
//  WebSocketChat.swift
//  RaidaChat
//
//  Created by Владислав on 13.12.2017.
//  Copyright © 2017 Владислав. All rights reserved.
//

import Foundation
import Starscream

class WebSocketChat: WebSocketDelegate {
    
    var listWebSocket: [String]!
    var webSocketList: [WebSocket] = []
    
    func websocketDidReceivePong(socket: WebSocket, data: Data?) {
        print("Got pong! Maybe some data: \(String(describing: data?.count))")
    }
    
    func websocketDidConnect(socket: WebSocket) {
        print("connected")
    }
    
    func websocketDidDisconnect(socket: WebSocket, error: NSError?) {
        print("websocket is disconnected: \(String(describing: error?.localizedDescription))")
    }
    
    func websocketDidReceiveMessage(socket: WebSocket, text: String) {
        print("got some text: \(text)")
    }
    
    func websocketDidReceiveData(socket: WebSocket, data: Data) {
        print("got some data: \(data.count)")
    }
    
    init(listWebSocket: [String]) {
        self.listWebSocket = listWebSocket
    }
    
    func conection() {
        for url in listWebSocket{
            if let url = URL(string: url){
                let socket = WebSocket(url: url)
                socket.delegate = self
                socket.connect()
                webSocketList.append(socket)
            }
            
        }
    }
    
}
