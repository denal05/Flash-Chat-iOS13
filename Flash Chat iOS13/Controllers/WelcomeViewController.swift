//
//  WelcomeViewController.swift
//  Flash Chat iOS13
//
//  Originally created by Angela Yu on 21/10/2019.
//  Adapted by Denis Aleksandrov on 2020-03-30.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit
import FirebaseAuth
import CLTypingLabel

class WelcomeViewController: UIViewController {
    let defaults = UserDefaults.standard
    var profileInfo: Dictionary = [
        "Email":  "--placeholder@email.com--"
    ]
    
    @IBOutlet weak var titleLabel: CLTypingLabel!
    @IBOutlet weak var emailTextField: UITextField!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //navigationController?.isNavigationBarHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("WelcomeViewController::" + #function + ": -------------------------------------------------------------------------------")
        
        /*
        // Manual Title Animation:
        titleLabel.text = ""
        var characterIndex = 0.0
        let titleText = "⚡️FlashChat"
        for letter in titleText {
            print("\(#function):  titleText[\(characterIndex)]=\(letter) 0.1 x characterIndex=\(0.1 * characterIndex)")
            Timer.scheduledTimer(withTimeInterval: 0.1 * characterIndex, repeats: false) { (timer) in
                self.titleLabel.text?.append(letter)
            }
            characterIndex += 1
        }
        */
        
        titleLabel.text = K.appName
        
        if let safeProfileInfo = defaults.dictionary(forKey: "profileInfo") as? Dictionary<String, String> {
            print("WelcomeViewController::" + #function + ": defaults.dictionary(forKey: \"profileInfo\") =  \(safeProfileInfo["Email"])")
            profileInfo = safeProfileInfo
        }
        
        print("WelcomeViewController::" + #function + ": profileInfo[\"Email\"] = \(self.profileInfo["Email"])")
        
        var handle = Auth.auth().addStateDidChangeListener { (fibAuth, fibUser) in
            if Auth.auth().currentUser != nil {
                // User is signed in.
                if let user = Auth.auth().currentUser {
                    print("WelcomeViewController::" + #function + ": Auth.auth().currentUser: " +
                            "\n | user.uid:   \(user.uid)" +
                            "\n | user.email: \(user.email ?? "NO_USER_EMAIL")")
                    if self.profileInfo["Email"] != user.email {
                        print("WelcomeViewController::" + #function + ": >>>> self.profileInfo[\"Email\"] != user.email")
                        self.profileInfo["Email"] = user.email
                        print("WelcomeViewController::" + #function + ": >>>> Setting self.profileInfo[\"Email\"] = user.email")
                        self.defaults.setValue(self.profileInfo, forKey: "profileInfo")
                        print("WelcomeViewController::" + #function + ": >>>> self.defaults.setValue(self.profileInfo, forKey: \"profileInfo\")")
                    }
                    self.performSegue(withIdentifier: K.welcomeToChatSegue, sender: self)
                }
            } else {
                print("WelcomeViewController::" + #function + ": Auth.auth().currentUser is nil | No user is signed in.")
            }
        }
    }
    
    @IBAction func nextButtonPressed(_ sender: UIBarButtonItem) {
        if let email = emailTextField.text {
            
            // https://stackoverflow.com/a/45364973/4669096
            Auth.auth().fetchSignInMethods(forEmail: email, completion: { (response, error) in
                if let e = error, let errCode = AuthErrorCode(rawValue: error?._code ?? -1) {
                    print("WelcomeViewController::" + #function + ": Auth.auth().fetchSignInMethods(forEmail: completion:) -> Error Code: \(errCode) | Error: \(e)")
                    let helper = Helper()
                    let alert = UIAlertController(title: "Error:", message: helper.alertUser(of: errCode) + "\n\(e.localizedDescription)", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                    self.present(alert, animated: true)
                    return
                } else {
                    print("WelcomeViewController::" + #function + ": Auth.auth().fetchSignInMethods(forEmail: completion:) -> Response: \(response)")
                    /*
                    let alert = UIAlertController(title: "Response:", message: "WelcomeViewController::" + #function + ": Auth.auth().fetchSignInMethods(forEmail: completion:) -> Response: \(response)", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                    self.present(alert, animated: true)
                    */
                    if let r = response {
                        if r[0] == "password" {
                            self.performSegue(withIdentifier: "WelcomeToLogin", sender: self)
                        } else {
                            print("WelcomeViewController::" + #function + ": Auth.auth().fetchSignInMethods(forEmail: completion:) -> Response: \(response) | Response is not password")
                        }
                    } else {
                        print("WelcomeViewController::" + #function + ": Auth.auth().fetchSignInMethods(forEmail: completion:) -> Response: nil")
                        self.performSegue(withIdentifier: "WelcomeToRegister", sender: self)
                    }
                }
            })
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.destination is LoginViewController
        {
            let vc = segue.destination as? LoginViewController
            if let safeEmail = self.emailTextField.text {
                vc?.email = safeEmail
            }
        }
        
        if segue.destination is RegisterViewController
        {
            let vc = segue.destination as? RegisterViewController
            if let safeEmail = self.emailTextField.text {
                vc?.email = safeEmail
            }
        }
    }
}
