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
class LoginViewController: UIViewController,UITextFieldDelegate,UIScrollViewDelegate {
    var signUp = false
    @IBOutlet weak var usernameTextField: KaedeTextField?
    @IBOutlet weak var passwordTextField: KaedeTextField?
    @IBOutlet weak var switchMode: UIButton!
    @IBOutlet weak var loginOrSignup: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var window: UIWindow?
    override func viewDidLoad() {
        super.viewDidLoad()
        switchMode.buttonShape()
        loginOrSignup.buttonShape()
        usernameTextField?.delegate = self
        passwordTextField?.delegate = self
        scrollView.delegate = self
        scrollView.bounces = false
        usernameTextField?.returnKeyType = UIReturnKeyType.next
        passwordTextField?.returnKeyType = UIReturnKeyType.done
    }
  
    override func viewDidAppear(_ animated: Bool) {
        if PFUser.current() != nil {
            self.performSegue(withIdentifier: "home", sender: self)
        }
    }

     func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == usernameTextField {
            passwordTextField?.becomeFirstResponder()
        } else if textField == passwordTextField {
        textField.resignFirstResponder()
        }
       return true
    }
    
    func displayAlert(title:String,message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            self.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func loginOrSignupButton(_ sender: Any) {
        if usernameTextField?.text == "" || passwordTextField?.text == "" {
            displayAlert(title: "ALERT", message: "please enter username and/or password")
        }
        else {
            if signUp {
                print ("signing up")
                let user = PFUser()
                user.username = usernameTextField?.text
                user.password = passwordTextField?.text
                user.email = usernameTextField?.text
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
                PFUser.logInWithUsername(inBackground: (usernameTextField?.text!)!, password: (passwordTextField?.text!)!, block: { (user, error) in
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
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "home"
        {
            if let destinationVC = segue.destination as? HomeCollectionViewController {
                destinationVC.isSearch = false
            }
        }
    }
}
extension UIButton {
    func buttonShape() {
        self.layer.cornerRadius = self.frame.height / 2
    }
}

extension UIScrollView {
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.next?.touchesBegan(touches, with: event)
        self.viewWithTag(2)?.endEditing(true)
    }
  
}

