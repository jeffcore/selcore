//
//  LoginViewController.swift
//  selcore
//
//  Created by Rix on 5/1/15.
//  Copyright (c) 2015 bitcore. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    
    let redButtonColor = UIColor(red: 249.0/255.0, green: 0/255.0, blue: 0.0/255.0, alpha: 1.0)
    var service = ParticleAPIService()
    var userDefaults:NSUserDefaults!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //remove the auto suggest keywords on keyboard
        self.usernameTextField.autocorrectionType = UITextAutocorrectionType.No
        self.passwordTextField.autocorrectionType = UITextAutocorrectionType.No
        
        //style the textfields
        self.usernameTextField.borderStyle = UITextBorderStyle.RoundedRect
        self.passwordTextField.borderStyle = UITextBorderStyle.RoundedRect
       
        //style the button
        self.loginButton.backgroundColor = redButtonColor
        self.loginButton.layer.cornerRadius = 5.0
        
        self.registerButton.backgroundColor = redButtonColor
        self.registerButton.layer.cornerRadius = 5.0

        
        //create user default object
        userDefaults = NSUserDefaults.standardUserDefaults()
        
        let defaults = NSUserDefaults.standardUserDefaults()
        if let token = defaults.stringForKey("token")
        {
            // LoginToCreateParticle
            //self.performSegueWithIdentifier("LoginToCreateParticle", sender: self)
            
        }
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginButtonClicked(sender: UIButton) {
        var error = false
        var alertString:String = ""
        
        if self.usernameTextField.text == "" && self.passwordTextField.text == "" {
            alertString = "No username or password entered"
            error = true
        } else {
            if self.usernameTextField.text == "" {
                alertString = "No username entered"
                error = true
            }
            
            if self.passwordTextField.text == "" {
                alertString = "No passwored entered"
                error = true
            }
        }
       
        if error {
            errorAlert(alertString)
        } else {
            let user = User(id: "0", username: self.usernameTextField.text!, email: "dropacid@gmail.com", password: self.passwordTextField.text!, numberTransactions: 0, rating: 0, createdOn: "12-25-2015")
            
            service.loginUser(user){
                (response: Int, data:NSDictionary) in
                print(data["token"]!)
                print(response)
                
                dispatch_async(dispatch_get_main_queue()){
                    self.userDefaults.setObject(data["token"]!, forKey: "token")
                    
                    let addAlert = UIAlertView(title: "User Added", message: "Successfully Added To Brain", delegate: self, cancelButtonTitle: "OK")
                    addAlert.show()
                    
                    self.performSegueWithIdentifier("LoginToListParticles", sender: self)
                }
            }
        }
    }
    
    
    
    func errorAlert(alertString: String){
        let alertVC = UIAlertController(title: "Error", message: alertString, preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "OK", style:.Default, handler: nil)
        alertVC.addAction(okAction)
        presentViewController(alertVC, animated: true, completion: nil)
    }

    
}

