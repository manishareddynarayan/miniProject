//
//  ViewController.swift
//  miniProject
//
//  Created by Manisha Reddy Narayan on 01/03/18.
//  Copyright © 2018 Manisha Reddy Narayan. All rights reserved.
//

import UIKit
import Parse
import TextFieldEffects

class LoginViewController: UIViewController {
    var signUp = false
    @IBOutlet weak var usernameTextField: KaedeTextField!
    @IBOutlet weak var passwordTextField: KaedeTextField!
    @IBOutlet weak var switchMode: UIButton!
    @IBOutlet weak var loginOrSignup: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        switchMode.buttonShape()
        loginOrSignup.buttonShape()
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func viewDidAppear(_ animated: Bool) {
        if PFUser.current() != nil {
            self.performSegue(withIdentifier: "home", sender: self)
        }
    }
    
    func displayAlert(title:String,message:String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            self.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func loginOrSignupButton(_ sender: Any) {
        if usernameTextField.text == "" || passwordTextField.text == "" {
            displayAlert(title: "ALERT", message: "please enter username and/or password")
        }
        else {
            if signUp {
                print ("signing up")
                let user = PFUser()
                user.username = usernameTextField.text
                user.password = passwordTextField.text
                user.email = usernameTextField.text
                user.signUpInBackground(block: { (success, error) in
                    if let error = error {
                        self.displayAlert(title: "Error in signing up", message: error.localizedDescription)
                        print(error)
                    }
                    else {
                        print("signing up")
                        self.performSegue(withIdentifier: "home", sender: self)
                    }
                })
                
            } else {
                PFUser.logInWithUsername(inBackground: usernameTextField.text!, password: passwordTextField.text!, block: { (user, error) in
                    if user != nil {
                        print("login successful")
                        self.performSegue(withIdentifier: "home", sender: self)
                        
                    } else {
                        if let error = error {
                            self.displayAlert(title: "Error in loginig in", message: error.localizedDescription)
                        }
                    }
                    
                })
            }
        }
    }
    
    @IBAction func switchButton(_ sender: Any) {
        if signUp {
            signUp = false
            loginOrSignup.setTitle("login", for: [])
            switchMode.setTitle("signUp", for: [])
        } else {
            signUp = true
            loginOrSignup.setTitle("signUp", for: [])
            switchMode.setTitle("login", for: [])
        }
    }
    
}
extension UIButton {
    func buttonShape() {
        self.layer.cornerRadius = self.frame.height / 2
    }
}

