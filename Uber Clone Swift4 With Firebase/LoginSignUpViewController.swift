//
//  ViewController.swift
//  Uber Clone Swift4 With Firebase
//
//  Created by Chaman Gurjar on 14/01/19.
//  Copyright © 2019 Chaman Gurjar. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginSignUpViewController: UIViewController {
    
    @IBOutlet weak var emailIdTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var riderDriverMode: UISwitch!
    @IBOutlet weak var loginSignUpButton: UIButton!
    @IBOutlet weak var flipModeButton: UIButton!
    @IBOutlet weak var riderLabel: UILabel!
    @IBOutlet weak var driverLabel: UILabel!
    
    private var isSignUpModeOn = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func loginSignUpUser(_ sender: UIButton) {
        if emailIdTF.text == "" || passwordTF.text == "" {
            displayAlert(title: "Oooh, Missing Information", message: "Please enter your email and password")
        } else {
            if isSignUpModeOn {
                signUpUser()
            } else {
                loginUser()
            }
        }
    }
    
    private func displayAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    private func signUpUser() {
        if let email = emailIdTF.text, let password = passwordTF.text {
            Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
                if error != nil {
                    self.displayAlert(title: "Error", message: error!.localizedDescription)
                } else {
                    print("SignUp Successful \(result?.user)")
                }
            }
        }
    }
    
    private func loginUser() {
        if let email = emailIdTF.text, let password = passwordTF.text {
            Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
                if error != nil {
                    self.displayAlert(title: "Error", message: error!.localizedDescription)
                } else {
                    print("Login Successful \(result?.user)")
                }
            }
        }
    }
    
    @IBAction func switchLoginSignUpMode(_ sender: UIButton) {
        if isSignUpModeOn {
            loginModeOn()
        } else {
            signUpModeOn()
        }
        
    }
    
    private func loginModeOn() {
        loginSignUpButton.setTitle("Login", for: .normal)
        flipModeButton.setTitle("Switch To Sign Up", for: .normal)
        riderLabel.isHidden = true
        driverLabel.isHidden = true
        riderDriverMode.isHidden = true
        isSignUpModeOn = false
    }
    
    private func signUpModeOn() {
        loginSignUpButton.setTitle("SignUp", for: .normal)
        flipModeButton.setTitle("Switch To Login", for: .normal)
        riderLabel.isHidden = false
        driverLabel.isHidden = false
        riderDriverMode.isHidden = false
        isSignUpModeOn = true
    }
    
}

