//
//  RegisterViewController.swift
//  Flash Chat iOS13
//
//  Originally created by Angela Yu on 21/10/2019.
//  Adapted by Denis Aleksandrov on 2020-04-01.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController {

    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    
    @IBAction func registerPressed(_ sender: UIButton) {

        if let email = emailTextfield.text, let password = passwordTextfield.text {
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if let e = error {
                    // TODO Implement validation and display error to user
                    print("\(#function): \(e.localizedDescription)")
                } else {
                    // Navigate to chat view controller
                    self.performSegue(withIdentifier: K.registerSegue, sender: self)
                }
            }
        }
    }
    
}
