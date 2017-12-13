//
//  ViewController.swift
//  RaidaChat
//
//  Created by Владислав on 16.11.2017.
//  Copyright © 2017 Владислав. All rights reserved.
//

import UIKit
import Starscream


class ViewController: UIViewController{
    
    
    var arrayOfTicket: [String] = []
    let conect = WebSocketChat(listWebSocket: ["ws://5.141.98.216:49011", "ws://5.141.98.216:49012"])
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        
        
//        if let url = URL(string: "ws://5.141.98.216:49011"){
//            socket = WebSocket(url: url)
//            socket.delegate = self
//            socket.pongDelegate = self
//            socket.connect()
//        }
        
    }
    
    @IBAction func reconnetc(_ sender: Any) {
//        let conect = WebSocketChat(listWebSocket: ["ws://5.141.98.216:49011", "ws://5.141.98.216:49012"])
        conect.conection()

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


