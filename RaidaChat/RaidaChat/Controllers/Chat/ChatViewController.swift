//
//  ChatController.swift
//  RaidaChat
//
//  Created by Владислав on 15.12.2017.
//  Copyright © 2017 Владислав. All rights reserved.
//

import UIKit

class ChatViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextViewDelegate {
    static let chatMessageFontSize: CGFloat = 17
    private static let toolBarMinHeight: CGFloat = 44
    private static let textViewMaxHeight: (portrait: CGFloat, landscape: CGFloat) = (portrait: 272, landscape: 90)
//    private static let messageSoundOutgoing: SystemSoundID = {
//        var soundID: SystemSoundID = 0
//        let soundURL = CFBundleCopyResourceURL(CFBundleGetMainBundle(), "MessageOutgoing", "aiff", nil)
//        AudioServicesCreateSystemSoundID(soundURL, &soundID)
//        return soundID
//    }()
    
    let chat: Chat!
    var tableView: UITableView!
    var toolBar: UIToolbar!
    var textView: UITextView!
    var sendButton: UIButton!
    var rotating = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        view.backgroundColor = .white
    }

    func setupTableView(){
        tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        let edgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: ChatViewController.toolBarMinHeight, right: 0)
        tableView.contentInset = edgeInsets
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.register(MessageSentDateTableViewCell.self, forCellReuseIdentifier: "SentDateCell")
        view.addSubview(tableView)
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(ChatViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        notificationCenter.addObserver(self, selector: #selector(ChatViewController.keyboardDidShow), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        notificationCenter.addObserver(self, selector: #selector(ChatViewController.menuControllerWillHide), name: NSNotification.Name.UIMenuControllerWillHideMenu, object: nil) // #CopyMessage

    }
    
    // Handle actions #CopyMessage
    // 1. Select row and show "Copy" menu
    @objc func messageShowMenuAction(gestureRecognizer: UITapGestureRecognizer) {
        let twoTaps = (gestureRecognizer.numberOfTapsRequired == 2)
        let doubleTap = (twoTaps && gestureRecognizer.state == .ended)
        let longPress = (!twoTaps && gestureRecognizer.state == .began)
        if doubleTap || longPress {
            let pressedIndexPath = tableView.indexPathForRow(at: gestureRecognizer.location(in: tableView))!
            tableView.selectRow(at: pressedIndexPath, animated: false, scrollPosition: .none)
            
            let menuController = UIMenuController.shared
            let bubbleImageView = gestureRecognizer.view!
            menuController.setTargetRect(bubbleImageView.frame, in: bubbleImageView.superview!)
            menuController.menuItems = [UIMenuItem(title: "Copy", action: #selector(ChatViewController.messageCopyTextAction))]
            menuController.setMenuVisible(true, animated: true)
        }
    }
    // 2. Copy text to pasteboard
    @objc func messageCopyTextAction(menuController: UIMenuController) {
        let selectedIndexPath = tableView.indexPathForSelectedRow
        let selectedMessage = chat.massanges[selectedIndexPath!.section][selectedIndexPath!.row-1]
        UIPasteboard.general.string = selectedMessage.textMsg
    }
    // 3. Deselect row
    @objc func menuControllerWillHide(notification: NSNotification) {
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: selectedIndexPath, animated: false)
        }
        (notification.object as! UIMenuController).menuItems = nil
    }
    
    override func viewDidAppear(_ animated: Bool)  {
        super.viewDidAppear(animated)
//        tableView.flashScrollIndicators()
    }
    
    override func viewWillDisappear(_ animated: Bool)  {
        super.viewWillDisappear(animated)
//        chat.draft = textView.text
    }
    
    override var inputAccessoryView: UIView! {
        get {
            if toolBar == nil {
                toolBar = UIToolbar(frame: CGRect.zero)
                
                textView = InputTextView(frame: CGRect.zero)
                textView.backgroundColor = UIColor(white: 250/255, alpha: 1)
                textView.delegate = self
                textView.font = UIFont.systemFont(ofSize: ChatViewController.chatMessageFontSize)
                textView.layer.borderColor = UIColor(red: 200/255, green: 200/255, blue: 205/255, alpha:1).cgColor
                textView.layer.borderWidth = 0.5
                textView.layer.cornerRadius = 5
                textView.scrollsToTop = false
                textView.textContainerInset = UIEdgeInsetsMake(4, 3, 3, 3)
                toolBar.addSubview(textView)
                
                sendButton = UIButton(type: .system)
                sendButton.isEnabled = false
                sendButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
                sendButton.setTitle("Send", for: .normal)
                sendButton.setTitleColor(UIColor(red: 142/255, green: 142/255, blue: 147/255, alpha: 1), for: .disabled)
                sendButton.setTitleColor(UIColor(red: 1/255, green: 122/255, blue: 255/255, alpha: 1), for: .normal)
                sendButton.contentEdgeInsets = UIEdgeInsets(top: 6, left: 6, bottom: 6, right: 6)
                sendButton.addTarget(self, action: #selector(ChatViewController.sendMessageAction), for: UIControlEvents.touchUpInside)
                toolBar.addSubview(sendButton)
                
                textView.translatesAutoresizingMaskIntoConstraints = false
                sendButton.translatesAutoresizingMaskIntoConstraints = false
                toolBar.addConstraint(NSLayoutConstraint(item: textView, attribute: .left, relatedBy: .equal, toItem: toolBar, attribute: .left, multiplier: 1, constant: 8))
                toolBar.addConstraint(NSLayoutConstraint(item: textView, attribute: .top, relatedBy: .equal, toItem: toolBar, attribute: .top, multiplier: 1, constant: 7.5))
                toolBar.addConstraint(NSLayoutConstraint(item: textView, attribute: .right, relatedBy: .equal, toItem: sendButton, attribute: .left, multiplier: 1, constant: -2))
                toolBar.addConstraint(NSLayoutConstraint(item: textView, attribute: .bottom, relatedBy: .equal, toItem: toolBar, attribute: .bottom, multiplier: 1, constant: -8))
                toolBar.addConstraint(NSLayoutConstraint(item: sendButton, attribute: .right, relatedBy: .equal, toItem: toolBar, attribute: .right, multiplier: 1, constant: 0))
                toolBar.addConstraint(NSLayoutConstraint(item: sendButton, attribute: .bottom, relatedBy: .equal, toItem: toolBar, attribute: .bottom, multiplier: 1, constant: -4.5))
            }
            return toolBar
        }
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        let userInfo = notification.userInfo as NSDictionary!
        let frameNew = (userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let insetNewBottom = tableView.convert(frameNew, from: nil).height
        let insetOld = tableView.contentInset
        let insetChange = insetNewBottom - insetOld.bottom
        let overflow = tableView.contentSize.height - (tableView.frame.height-insetOld.top-insetOld.bottom)
        
        let duration = (userInfo![UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        let animations: (() -> Void) = {
            if !(self.tableView.isTracking || self.tableView.isDecelerating) {
                // Move content with keyboard
                if overflow > 0 {                   // scrollable before
                    self.tableView.contentOffset.y += insetChange
                    if self.tableView.contentOffset.y < -insetOld.top {
                        self.tableView.contentOffset.y = -insetOld.top
                    }
                } else if insetChange > -overflow { // scrollable after
                    self.tableView.contentOffset.y += insetChange + overflow
                }
            }
        }
        if duration > 0 {
            let options = UIViewAnimationOptions(rawValue: UInt((userInfo![UIKeyboardAnimationCurveUserInfoKey] as! NSNumber).intValue << 16)) // http://stackoverflow.com/a/18873820/242933
            UIView.animate(withDuration: duration, delay: 0, options: options, animations: animations, completion: nil)
        } else {
            animations()
        }
    }
    
    @objc func keyboardDidShow(notification: NSNotification) {
        let userInfo = notification.userInfo as NSDictionary!
        let frameNew = (userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let insetNewBottom = tableView.convert(frameNew, from: nil).height
        
        // Inset `tableView` with keyboard
        let contentOffsetY = tableView.contentOffset.y
        tableView.contentInset.bottom = insetNewBottom
        tableView.scrollIndicatorInsets.bottom = insetNewBottom
        // Prevents jump after keyboard dismissal
        if self.tableView.isTracking || self.tableView.isDecelerating {
            tableView.contentOffset.y = contentOffsetY
        }
    }
    
    @objc func sendMessageAction() {
        // Autocomplete text before sending #hack
        textView.resignFirstResponder()
        textView.becomeFirstResponder()
        
        
        let messageText = textView.text
        let date = NSDate()
//        chat.loadedMessages.append([Message(incoming: false, text: messageText, sentDate: date)])
//        chat.lastMessageText = messageText
//        chat.lastMessageSentDate = date
//        NSNotificationCenter.defaultCenter().postNotificationName(AccountDidSendMessageNotification, object: chat)
//
//        textView.text = nil
//        updateTextViewHeight()
//        sendButton.enabled = false
//
//        let lastSection = tableView.numberOfSections
//        tableView.beginUpdates()
//        tableView.insertSections(NSIndexSet(index: lastSection), withRowAnimation: .Automatic)
//        tableView.insertRowsAtIndexPaths([
//            NSIndexPath(forRow: 0, inSection: lastSection),
//            NSIndexPath(forRow: 1, inSection: lastSection)
//            ], withRowAnimation: .Automatic)
//        tableView.endUpdates()
//        tableViewScrollToBottomAnimated(true)
//        AudioServicesPlaySystemSound(ChatViewController.messageSoundOutgoing)
    }

    
    init(chat: Chat) {
        self.chat = chat
        super.init(nibName: nil, bundle: nil)
        hidesBottomBarWhenPushed = true
        title = chat.name
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
    }

    func textViewDidChange(_ textView: UITextView) {
        updateTextViewHeight()
        sendButton.isEnabled = textView.hasText
    }
    
    func updateTextViewHeight() {
        let oldHeight = textView.frame.height
        let maxHeight = UIInterfaceOrientationIsPortrait(interfaceOrientation) ? ChatViewController.textViewMaxHeight.portrait : ChatViewController.textViewMaxHeight.landscape
        var newHeight = min(textView.sizeThatFits(CGSize(width: textView.frame.width, height: CGFloat.greatestFiniteMagnitude)).height, maxHeight)
        #if arch(x86_64) || arch(arm64)
            newHeight = ceil(newHeight)
        #else
            newHeight = CGFloat(ceilf(newHeight.native))
        #endif
        if newHeight != oldHeight {
            toolBar.frame.size.height = newHeight+8*2-0.5
        }
    }
    
    // MARK:  - UITableViewDataCou
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        return cell
    }
}

class InputTextView: UITextView {
    // Only show "Copy" when selecting a row while `textView` is first responder #CopyMessage
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if (delegate as! ChatViewController).tableView.indexPathForSelectedRow != nil {
            return action == #selector(ChatViewController.messageCopyTextAction)
        } else {
            return super.canPerformAction(action, withSender: sender)
        }
    }
    
    
    // More specific than implementing `nextResponder` to return `delegate`, which might cause side effects?
    func messageCopyTextAction(menuController: UIMenuController) {
        (delegate as! ChatViewController).messageCopyTextAction(menuController: menuController)
    }
}








