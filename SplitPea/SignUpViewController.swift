//
//  SignUpViewController.swift
//  SplitPea
//
//  Created by Vinizzle on 2/13/15.
//  Copyright (c) 2015 OkraLabs. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController, UITextFieldDelegate{

    @IBOutlet weak var userPhone: UITextField!
    @IBOutlet weak var userPassword: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.userPassword.delegate = self;
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(userPassword: UITextField!) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    @IBAction func addUserToDB(sender: AnyObject) {
        if (userPhone.text != "" && userPassword.text != "") {
            var user = PFUser()
            user.username = userPhone.text
            user.password = userPassword.text
            user.signUpInBackgroundWithBlock {
                (succeeded: Bool!, error: NSError!) -> Void in
                if error == nil {
                    // Hooray! Let them use the app now.
//                    println("User sent to Parse")
                    self.performSegueWithIdentifier("signUpWithFB", sender: self)
                } else {
                    // Show the errorString somewhere and let the user try again.
//                    println("You're a shitty coder")
                }
            }
            user.pin()
            
        } else {
            var alert = UIAlertController(title: "Oops..", message: "Either your username isn't a valid US number or you haven't entered a password!", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
        }
    }
    

}
