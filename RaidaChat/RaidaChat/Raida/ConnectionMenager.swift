//
//  WebSocketChat.swift
//  RaidaChat
//
//  Created by Владислав on 13.12.2017.
//  Copyright © 2017 Владислав. All rights reserved.
// 77777777777777777777777777777777

import Foundation
import Starscream


protocol ReceiptAnswerDeligate {
    func responseRegistration(data: Data)
    func responseGetMsg(data: Data)
    func responseGetMyDialog(data: Data)
    func responseCreateGroup(data: Data)
    func responseAddMemberInGroup(data: Data)
    func responseSendMsg(data: Data)
    func responseAutorization(data: Data)
}

class ConnectionMenager: WebSocketDelegate {
    
    var listWebSocketUrl: [String]!
    var webSocketList: [WebSocket] = []
    var countConnect = 0
    var deligateReceiptAnswer: ReceiptAnswerDeligate!
    
    func websocketDidReceivePong(socket: WebSocket, data: Data?) {
        print("Got pong! Maybe some data: \(String(describing: data?.count))")
        do {
            let response = try JSONDecoder().decode(FunctionRaida.self, from: data!)
            checkMsg(execFun: response, data: data!)
        } catch {
            print(error)
        }
    }
    
    func websocketDidConnect(socket: WebSocket) {
        print("connected")
        countConnect += 1
        
    }
    
    func websocketDidDisconnect(socket: WebSocket, error: NSError?) {
        print("websocket is disconnected: \(String(describing: error?.localizedDescription))")
        countConnect -= 1
    }
    
    func websocketDidReceiveMessage(socket: WebSocket, text: String) {
        do {
            print(text)
            let data = text.data(using: .utf8)
            let response = try JSONDecoder().decode(FunctionRaida.self, from: data!)
            checkMsg(execFun: response, data: data!)
        } catch {
            print(error)
        }
    }
    
    func websocketDidReceiveData(socket: WebSocket, data: Data) {
        print("got some data: \(data.count)")
    }
    
    init(listWebSocket: [String]) {
        self.listWebSocketUrl = listWebSocket
    }
    
    fileprivate func checkMsg(execFun: FunctionRaida, data: Data){
        if execFun.success == true{
            switch execFun.callFunction {
            case CalledFunc.registration.rawValue:
                deligateReceiptAnswer.responseRegistration(data: data)
            case CalledFunc.getMsg.rawValue:
                deligateReceiptAnswer.responseGetMsg(data: data)
            case CalledFunc.getMyDialogs.rawValue:
                deligateReceiptAnswer.responseGetMyDialog(data: data)
            case CalledFunc.createGroup.rawValue:
                deligateReceiptAnswer.responseCreateGroup(data: data)
            case CalledFunc.addMemberInGroup.rawValue:
                deligateReceiptAnswer.responseCreateGroup(data: data)
            case CalledFunc.sendMsg.rawValue:
                deligateReceiptAnswer.responseSendMsg(data: data)
            case CalledFunc.autorization.rawValue:
                deligateReceiptAnswer.responseAutorization(data: data)
            default:
                print(execFun.callFunction)
                print(execFun.msgError)
            }
        } else {
            print(execFun)
        }
    }
    
    func conection() {
        for url in listWebSocketUrl{
            if let url = URL(string: url){
                let socket = WebSocket(url: url)
                socket.delegate = self
                socket.connect()
                webSocketList.append(socket)
            }
            
        }
    }
    
    
    func writeAllWebSockets(data: Data){
        for socket in webSocketList {
            socket.write(data: data)
        }
    }
    
    func writeAllWebSockets(string: String){
        print(string)
        for socket in webSocketList {
            socket.write(string: string)
        }
    }

    
}

