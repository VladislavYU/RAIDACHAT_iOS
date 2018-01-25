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
    
    @IBOutlet weak var login: UITextField!
    @IBOutlet weak var password: UITextField!
    
    let limitLength = 32
    var arrayOfTicket: [String] = []
    let raida = ControllerRaida(listURL: ["ws://5.141.98.216:49011",
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
        login.delegate = self
        password.delegate = self
        hideKeyboardWhenTappedAround()
        login.text = "Waldemar"
        password.text = "22222222222222222222222222222222"
        
    }
    
    
    
    @IBAction func conection(_ sender: Any) {
        let chatsController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ChatsController") as! ChatsViewController
        chatsController.raida = self.raida

        raida.requestAutorization(login: login.text!, password: password.text!)
        present(chatsController, animated: true, completion: nil)
    }
    @IBAction func showRegistration(_ sender: Any) {
        guard let registration = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Registration") as? RegistrationViewController else { return }
        registration.raida = self.raida
        showDetailViewController(registration, sender: self)
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

extension UIViewController: UITextFieldDelegate{
    static let limitLength = 32
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let newLength = text.count + string.count - range.length
        return newLength <= UIViewController.limitLength
    }
}


