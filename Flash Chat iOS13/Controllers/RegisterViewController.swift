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
    let defaults = UserDefaults.standard
    var profileInfo: Dictionary = [
        "Email":  "--placeholder@email.com--"
    ]
    
    var email: String = ""
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("RegisterViewController::" + #function + ": -------------------------------------------------------------------------------")
        
        if let safeProfileInfo = defaults.dictionary(forKey: "profileInfo") as? Dictionary<String, String> {
            print("RegisterViewController::" + #function + ": defaults.dictionary(forKey: \"profileInfo\") =  \(safeProfileInfo["Email"])")
            profileInfo = safeProfileInfo
        }
        
        print("RegisterViewController::" + #function + ": profileInfo[\"Email\"] = \(self.profileInfo["Email"])")
        
        var handle = Auth.auth().addStateDidChangeListener { (fibAuth, fibUser) in
            if Auth.auth().currentUser != nil {
                // User is signed in.
                if let user = Auth.auth().currentUser {
                    print("RegisterViewController::" + #function + ": Auth.auth().currentUser: " +
                            "\n | user.uid:   \(user.uid)" +
                            "\n | user.email: \(user.email ?? "NO_USER_EMAIL")")
                    if self.profileInfo["Email"] != user.email {
                        self.profileInfo["Email"] = user.email
                        self.defaults.setValue(self.profileInfo, forKey: "profileInfo")
                    }
                    // performSegue...
                }
            } else {
                print("RegisterViewController::" + #function + ": Auth.auth().currentUser is nil | No user is signed in.")
            }
        }
        
        if self.email != "" {
            emailTextField.text = self.email
            print("RegisterViewController::" + #function + ": WARNING -- self.email was prepopulated from another view controller")
        }
    }
    
    @IBAction func registerButtonPressed(_ sender: UIButton) {
        if let email = emailTextField.text, let password = passwordTextField.text {
            if email == "" {
                let alert = UIAlertController(title: "Email Required:", message: "Please enter a valid email address.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                self.present(alert, animated: true)
                return
            }
            
            if password == "" {
                let alert = UIAlertController(title: "Password Required:", message: "Please enter a valid password.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                self.present(alert, animated: true)
                return
            }
            
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if let e = error, let errCode = AuthErrorCode(rawValue: error?._code ?? -1) {
                    print("RegisterViewController::" + #function + ": Auth.auth().createUser(withEmail: password:) -> Error Code: \(errCode) | Error: \(e)")
                    let helper = Helper()
                    let alert = UIAlertController(title: "Error:", message: helper.alertUser(of: errCode) + "\n\(e.localizedDescription)", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                    self.present(alert, animated: true)
                    return
                } else {
                    self.profileInfo["Email"] = email
                    self.defaults.setValue(self.profileInfo, forKey: "profileInfo")
                    self.performSegue(withIdentifier: K.registerToChatSegue, sender: self)
                }
            }
        }
    }
    
}
