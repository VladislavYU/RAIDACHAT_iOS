//
//  GroupChatTableViewController.swift
//  RaidaChat
//
//  Created by Владислав on 13.12.2017.
//  Copyright © 2017 Владислав. All rights reserved.
//

import UIKit

class ChatsViewController: UITableViewController {
    
    
    var listChats: [Dialog] = []
    var raida: ControllerRaida!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        raida.deligateDialog = self
//        raida.requestGetMyDialog()
        raida.requestGetMsg(getAll: true, onGroup: false, onlyId: "")
//        socketChat.webSocketList[0]21.onText = { (text: String) in
//            do {
//                let data = text.data(using: .utf8)
//                let json = try JSONSerialization.jsonObject(with: data!, options: [])
//
//                if let groups = json["data"].
//            } catch {
//                print(error)
//            }
        
//        }
        
    }
    
    func setupTableView(){
        tableView.tableFooterView = UIView()
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
        let chat = listChats[indexPath.row]
        let chatView = ChatViewController(chat: chat)
        
        present(chatView, animated: true, completion: nil)
    }

}

extension ChatsViewController: RaidaDialogsDeligate{
    func getDialogs(dialogs: [Dialog]?) {
        guard dialogs != nil else {
            print("dialogs == nil")
            return
        }
        listChats = dialogs!
        tableView.reloadData()
    }
    
    
}

