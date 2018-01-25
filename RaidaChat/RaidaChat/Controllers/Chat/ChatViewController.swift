//
//  ChatController.swift
//  RaidaChat
//
//  Created by Владислав on 15.12.2017.
//  Copyright © 2017 Владислав. All rights reserved.
//

import UIKit

class ChatViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextViewDelegate {
    
    private static let toolBarMinHeight: CGFloat = 44
    
    var chat: Dialog
    var tableView: UITableView!
    var toolBar: UIToolbar!
    var textView: UITextView!
    var sendButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        let edgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: ChatViewController.toolBarMinHeight, right: 0)
        tableView.contentInset = edgeInsets
        tableView.dataSource = self
        tableView.delegate = self
        tableView.keyboardDismissMode = .interactive
        tableView.estimatedRowHeight = 44
//        tableView.separatorStyle = .Nones
        tableView.register(MessageSentDateTableViewCell.self, forCellReuseIdentifier: "SentDateCell")
        
        
        view.backgroundColor = .white
        toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        toolBar.tintColor = .black
        self.view.addSubview(tableView)
    }
    
    
    
    
    
    init(chat: Dialog) {
        self.chat = chat
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return chat.massanges.count
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = MessageSentDateTableViewCell()
        
        
        return cell
    }
    
}








