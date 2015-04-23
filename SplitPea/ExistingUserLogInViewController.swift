//
//  ExistingUserLogInViewController.swift
//  SplitPea
//
//  Created by Vinizzle on 4/20/15.
//  Copyright (c) 2015 OkraLabs. All rights reserved.
//

import UIKit

class ExistingUserLogInViewController: UIViewController {

    @IBOutlet weak var userName: UITextField!
    
    @IBOutlet weak var passWord: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    

    @IBAction func logIn(sender: AnyObject) {
        var username = self.userName.text as String
        var password = self.passWord.text as String
        PFUser.logInWithUsernameInBackground(username, password: password) {
            (user: PFUser!, error: NSError!) -> Void in
            if (error != nil) {
                var alert = UIAlertController(title: "Error!", message: "Incorrect Username/ Password!", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            } else {
                self.performSegueWithIdentifier("existingUserLoggedIn", sender: self)
            }
        }
    }
    
    @IBAction func forgotPassword(sender: AnyObject) {
        var alert = UIAlertController(title: "Forgot Password?", message: "Enter email connected to your Facebook!", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addTextFieldWithConfigurationHandler {
            (textField: UITextField!) -> Void in
            println("configurat hire the TextField")
            textField.placeholder = "facebook e-mail"
        }
        alert.addAction(UIAlertAction(title: "Done", style: UIAlertActionStyle.Default, handler: {
            (action: UIAlertAction!) -> Void in
//            code
        }))
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
