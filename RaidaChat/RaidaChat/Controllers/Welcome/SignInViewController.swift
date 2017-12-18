//
//  ViewController.swift
//  RaidaChat
//
//  Created by Владислав on 16.11.2017.
//  Copyright © 2017 Владислав. All rights reserved.
//

import UIKit
import Starscream


class SignInViewController: UIViewController{
    
    
    var arrayOfTicket: [String] = []
    let socketChat = WebSocketChatMenager(listWebSocket: ["ws://5.141.98.216:49011",
                                               "ws://5.141.98.216:49012",
                                               "ws://5.141.98.216:49013",
                                               "ws://5.141.98.216:49014",
                                               "ws://5.141.98.216:49015",
                                               "ws://5.141.98.216:49016",
                                               "ws://5.141.98.216:49017",
                                               "ws://5.141.98.216:49018",
                                               "ws://5.141.98.216:49019",
                                               "ws://5.141.98.216:49020"])
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        socketChat.conection()
        
    }
    
    @IBAction func conection(_ sender: Any) {
        let chatsController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ChatsController") as! ChatsViewController
        chatsController.socketChat = self.socketChat
        socketChat.authorization(login: "77777777777777777777777777777777", password: "77777777777777777777777777777777")

        present(chatsController, animated: true, completion: nil)
//        show(chatsController, sender: nil)
    }
}

extension UIViewController{
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
}


