//
//  GroupChatTableViewController.swift
//  RaidaChat
//
//  Created by Владислав on 13.12.2017.
//  Copyright © 2017 Владислав. All rights reserved.
//

import UIKit

class ChatsViewController: UITableViewController {
    
    
    var listChats: [Chat] = [Chat(id: 1, name: "1"), Chat(id: 2, name: "2")]
    var socketChat: WebSocketChatMenager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        socketChat.getMyDialogs()
        
        for socket in socketChat.webSocketList{
            socket.onText = { (text: String) in
            
            }
        }
        
    }


    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listChats.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatCell", for: indexPath) as! ChatViewCell
        let chat = listChats[indexPath.row]
        cell.textLabel?.text = chat.name

        return cell
    }
 
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let chat = listChats[indexPath.row]
        let chat = Chat(id: 1, name: "odin")
        let chatView = ChatViewController(chat: chat)
        socketChat.getMessange()
        
        present(chatView, animated: true, completion: nil)
    }

}

