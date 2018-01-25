//
//  ControllerRaida.swift
//  RaidaChat
//
//  Created by Владислав on 23.01.2018.
//  Copyright © 2018 Владислав. All rights reserved.
//

import Foundation


protocol RaidaDialogsDeligate {
    func getDialogs(dialogs: [Dialog]?)
}

protocol RaidaMessagesDeligate {
    func getAllMessages(messages: [Message])
}

class ControllerRaida {
    
    private var listUrlStringWebSocket: [String]
    private var responseForAuth: [Data] = [] //Объект для хранения сообщений при авторизации
    private var responseForReg: [Data] = [] //Объект для хранения сообщений при регистрации
    private var responseForGetMsg: [Data] = [] //Объект для хранения сообщений при регистрации
    private var responseForNewGr: [Data] = [] //Объект для хранения сообщений при создании групы
    private var responseForAddMemb: [Data] = [] //Объект для хранения сообщений при добавлении пользователя в группу
    private var responseForGetMyGroup: [Data] = [] //Объект для хранения сообщений при создании группы
    private var responseForSendMsg: [Data] = []
    private var bufferSendingMsg: [Data] = []   //Массив всех входных сообщений с callFun = sendMsg
    //    var dictionarySendingMsg = {}; //Распределённые сообщения по ИД
    private let conectionManager: ConnectionMenager!

    var deligateDialog: RaidaDialogsDeligate?
    var deligateAllMessages: RaidaMessagesDeligate?
    
    init(listURL: [String]) {
        self.listUrlStringWebSocket = listURL
        conectionManager = ConnectionMenager(listWebSocket: listURL)
        conectionManager.deligateReceiptAnswer = self
        conectionManager.conection()
    }
    
    public func requestRegistration(login: String, password: String) {
        let json: [String : Any] = ["execFun" : CalledFunc.registration.rawValue,
                    "data" : [
                        "login": login,
                        "an": password,
                        "publicId": String(describing: UUID())]]
        if let data = JSON.getJSONString(json){
            conectionManager.writeAllWebSockets(string: data)
        }
    }
    
    public func requestAutorization(login: String, password: String) {
        let json: [String : Any] = ["execFun" : CalledFunc.autorization.rawValue,
                                    "data" : [
                                        "login": login,
                                        "an": password]]
        if let data = JSON.getJSONString(json){
            conectionManager.writeAllWebSockets(string: data)
        }
    }
    
    public func requestGetMyDialog() {
        let json: [String : Any] = ["execFun" : CalledFunc.getMyDialogs.rawValue,
                                    "data" : ""]
        if let data = JSON.getJSONString(json){
            conectionManager.writeAllWebSockets(string: data)
        }
    }
    
    public func requestAddMemberInGroup(memberLogin: String, groupId: String) {
        let json: [String : Any] = ["execFun" : CalledFunc.addMemberInGroup.rawValue,
                                    "data" : [
                                        "memberLogin" : memberLogin,
                                        "groupId" : groupId]]
        if let data = JSON.getJSONString(json){
            conectionManager.writeAllWebSockets(string: data)
        }
    }
    
    public func requestCreateGroup(groupName: String){
        let guid = String(describing: UUID())
        let json: [String : Any] = ["execFun" : CalledFunc.createGroup.rawValue,
                                    "data" : [
                                        "groupName" : groupName,
                                        "public_id" : guid]]
        if let data = JSON.getJSONString(json){
            conectionManager.writeAllWebSockets(string: data)
        }
    }
    
    public func requestGetMsg(getAll: Bool, onGroup: Bool, onlyId: String){
        let json : [String : Any] = ["execFun" : CalledFunc.getMsg.rawValue,
                                     "data" : [
                                        "getAll" : getAll
//                                        "onGroup" : onGroup,
//                                        "onlyId" : onlyId
            ]]
        if let data = JSON.getJSONString(json){
            conectionManager.writeAllWebSockets(string: data)
        }
    }
    
    private func checkResponseCount(stack: [Data], completionHandler: @escaping ([Data]) -> ()){
        if conectionManager.countConnect == stack.count {
                completionHandler(stack)
        }
    }
    
    private func checkIdenticalData(stack: [Data]) -> Bool{
        var item: Data? = nil
        for i in 0...stack.count-1 {
            if item == nil {
                item = stack[i]
            } else {
                if stack[i] != item{
                    return false
                }}
        }
        return true
    }
    
}

extension ControllerRaida: ReceiptAnswerDeligate{
    func responseSendMsg(data: Data) {
        responseForSendMsg.append(data)
        checkResponseCount(stack: responseForSendMsg) { stack in
            if self.checkIdenticalData(stack: stack){
                
            }
        }
    }
    
    func responseAutorization(data: Data) {
        responseForAuth.append(data)
    }
    
    func responseRegistration(data: Data) {
        responseForReg.append(data)
    }
    
    func responseGetMsg(data: Data) {
        responseForGetMsg.append(data)
        checkResponseCount(stack: responseForGetMsg) { (stack) in
            var listMessages = [Message]()
            for item in stack {
                if let array = JSON.getMessages(data: item){
                    listMessages += array
                }
            }
            let messagesDecode = MessageUtil.decode(partsMesage: listMessages)!
            self.deligateAllMessages?.getAllMessages(messages: messagesDecode)
        }
    }
    
    func responseGetMyDialog(data: Data) {
        responseForGetMyGroup.append(data)
        checkResponseCount(stack: responseForGetMyGroup) { (stack) in
            if self.checkIdenticalData(stack: stack){
                if let array = JSON.getDialogs(data: stack[0]){
                    self.deligateDialog?.getDialogs(dialogs: array)
                }
            }
        }
    }
    
    func responseCreateGroup(data: Data) {
        responseForNewGr.append(data)
    }
    
    func responseAddMemberInGroup(data: Data) {
        responseForAddMemb.append(data)
    }
    
    func responseResponseSendMsg(data: Data) {
        responseForSendMsg.append(data)
    }
    
    
    
}
