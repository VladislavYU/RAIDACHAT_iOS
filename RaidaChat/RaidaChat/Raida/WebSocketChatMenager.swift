//
//  WebSocketChat.swift
//  RaidaChat
//
//  Created by Владислав on 13.12.2017.
//  Copyright © 2017 Владислав. All rights reserved.
// 77777777777777777777777777777777

import Foundation
import Starscream
import SwiftyJSON

class WebSocketChatMenager: WebSocketDelegate {
    
    var listWebSocketUrl: [String]!
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
        let json = JSON(text)
        print(json)
        
    }
    
    func websocketDidReceiveData(socket: WebSocket, data: Data) {
        print("got some data: \(data.count)")
    }
    
    init(listWebSocket: [String]) {
        self.listWebSocketUrl = listWebSocket
    }
    
    public func conection() {
        for url in listWebSocketUrl{
            if let url = URL(string: url){
                let socket = WebSocket(url: url)
                socket.delegate = self
                socket.connect()
                webSocketList.append(socket)
            }
            
        }
    }
    
    
    public func authorization(login: String, password: String){
        let parametrs: [String : Any] = ["execFun" : RaidaFunction.authorization, "data" : [
            "login" : login,
            "an" : password]]
        var jsonObject: NSData? = nil
        
        
        let textJson = """
        {
        \"execFun\": \"authorization\",
        \"data\": {
            \"login\": \"\(login)\",
            \"an\": \"\(password)\"
            }
        }
        """
        
        for socket in webSocketList{
            socket.write(string: textJson)
        }
    }
    
    public func creationNewGroup(){
        
    }
 
    public func addMemberInGroup(){
        
    }
    
    public func sendMessange(){
        
    }
    
    public func getMessange(){
        let textJson = """
            {
            \"execFun\": \"getMsg\",
            \"data\": {
            \"getAll\": \(true),
            "onGroup": \(false),
            \"onlyId\": \"GUID - sender_id\"
                }
            }
            """
        
        for socket in webSocketList{
            socket.write(string: textJson)
        }
        
    }
    
    public func getMyDialogs(){
        let textJson = """
        {
            "execFun": "getMyDialogs",
            "data": {}
                }
        """
        for socket in webSocketList{
            socket.write(string: textJson)
        }
    }
    
    
}

