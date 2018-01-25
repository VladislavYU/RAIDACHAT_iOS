//
//  MassageManager.swift
//  RaidaChat
//
//  Created by Владислав on 23.01.2018.
//  Copyright © 2018 Владислав. All rights reserved.
//

import Foundation

class MessageUtil {
    
    static func decode(partsMesage: [Message]) -> [Message]? {
        var list = partsMesage.sorted { (first, second) -> Bool in
            if first.guidMsg == second.guidMsg{
                return first.curFrg < second.curFrg
            }
            return first.guidMsg < second.guidMsg
        }
        
        var messages: [Message] = []
        var curentMassage = 0
        while curentMassage != list.count {
            var text = ""
            var j = 0
            while j < list[curentMassage].textMsg.count {
                var k = 0
                while k < list[curentMassage].totalFrg{
                    if list[curentMassage + k].textMsg.count <= list[curentMassage].textMsg.count{
                        let str = list[curentMassage + k].textMsg
                        let charInd = str.index(str.startIndex, offsetBy: j )
                        if j + 1 > str.count{
                            text += ""
                        } else {
                            text += String(str[charInd])
                        }
                    }
                    k += 1
                }
                j += 1
            }
            list[curentMassage].textMsg = text
            messages.append(list[curentMassage])
            curentMassage += list[curentMassage].totalFrg
        }
        
        var listMessage: [Message] = []
        for var item in messages{
            item.textMsg = item.textMsg.fromBase64()!
            listMessage.append(item)
        }
        return listMessage
        
    }
    
    static func encode() {
        
    }
}

extension String {
    
    func fromBase64() -> String? {
        guard let data = Data(base64Encoded: self, options: Data.Base64DecodingOptions(rawValue: 0)) else {
            return nil
        }
        
        return String(data: data as Data, encoding: String.Encoding.utf8)
    }
    
    func toBase64() -> String? {
        guard let data = self.data(using: String.Encoding.utf8) else {
            return nil
        }
        
        return data.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: 0))
    }
}


//fun decodeMessage(partsMessage: ArrayList<Message>): ArrayList<Message>? {
//    try {
//    // сортируем массив с кусочками сообщений
//    var list = partsMessage.sortedWith(compareBy({ it.id }, { it.curFrg }))
//    // Вывод в лог
//    // list.forEach { debug("${it.mId} / ${it.mCurrentFragment} / ${it.mText}") }
//    // Собираем кусочки
//    val messages = arrayListOf<Message>()
//    var currentMessage = 0
//    var i = 0
//    while (currentMessage != list.size) {
//    var text = ""
//    var j = 0
//    while (j < list[currentMessage].text.length) {
//    var k = 0
//    while (k < list[currentMessage].totalFrg) {
//    try {
//    if (list[currentMessage + k].text.length <= list[currentMessage].text.length)
//    text += list[currentMessage + k].text[j]
//    } catch (e: Exception) {
//    }
//    k++
//    }
//    j++
//    }
//    list[currentMessage].text = text
//    messages.add(list[currentMessage])
//    currentMessage += list[currentMessage].totalFrg
//    }
//    // Вывод в лог
//    messages.forEach { debug("${it.id} / ${it.curFrg} / ${it.text}") }
//    // Декодируем
//    messages.forEach {
//    try {
//    it.text = Base64.decode(it.text, Base64.DEFAULT).toString(Charset.forName("UTF-8"))
//    debug(it.text)
//    } catch (e: Exception) {
//    err(e.message.toString())
//    }
//    }
//    return messages
//    } catch (e: Exception) {
//    e.printStackTrace()
//    } finally {
//        return null
//    }
//}

