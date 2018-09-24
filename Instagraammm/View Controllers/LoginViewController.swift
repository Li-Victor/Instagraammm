//
//  LoginViewController.swift
//  Instagram
//
//  Created by Victor Li on 9/18/18.
//  Copyright © 2018 Victor Li. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController {

    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    
    @IBAction func onSignIn(_ sender: Any) {
        
        indicator.isHidden = false
        PFUser.logInWithUsername(inBackground: usernameField.text!, password: passwordField.text!) { (user: PFUser?, error: Error?) in
            self.indicator.isHidden = true
            if user != nil {
                self.performSegue(withIdentifier: "goToHomeSegue", sender: nil)
            }
        }
    }
    
    @IBAction func onSignUp(_ sender: Any) {
        let newUser = PFUser()
        
        indicator.isHidden = false
        
        newUser.username = usernameField.text
        newUser.password = passwordField.text
        newUser.signUpInBackground { (success: Bool, error: Error?) in
            self.indicator.isHidden = true
            if success {
                print("created a new user")
            } else {
                print(error?.localizedDescription ?? "error")
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loginButton.layer.cornerRadius = 5
        signupButton.layer.cornerRadius = 5
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
