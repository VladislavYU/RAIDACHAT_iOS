//
//  RegistrationViewController.swift
//  RaidaChat
//
//  Created by Владислав on 14.01.2018.
//  Copyright © 2018 Владислав. All rights reserved.
//

import UIKit

class RegistrationViewController: UIViewController {
    
    var raida: ControllerRaida!
    
    @IBOutlet weak var login: UITextField!
    @IBOutlet weak var password: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        login.delegate = self
        password.delegate = self
        hideKeyboardWhenTappedAround()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func tapRegistration(_ sender: Any) {
        raida.requestRegistration(login: login.text!, password: password.text!)
        self.navigationController?.popViewController(animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
