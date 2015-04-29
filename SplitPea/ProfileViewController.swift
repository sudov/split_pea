//
//  ProfileViewController.swift
//  SplitPea
//
//  Created by Vinizzle on 1/10/15.
//  Copyright (c) 2015 OkraLabs. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var old_password: UITextField!
    @IBOutlet weak var new_password: UITextField!
    @IBOutlet weak var confirm_new_password: UITextField!
    
    @IBOutlet weak var old_email: UITextField!
    @IBOutlet weak var new_email: UITextField!
    @IBOutlet weak var confirm_new_email: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.sharedApplication().statusBarStyle = .LightContent
    }

    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    @IBAction func doneUpdatingPassword(sender: AnyObject) {
        var old_pwd = PFUser.currentUser().password as String
        var alert = UIAlertView()
        if (old_password.text == "\(old_pwd)") {
            if (new_password.text == confirm_new_password.text) {
                PFUser.currentUser().password = new_password.text as String
                alert.title   = "Great!"
                alert.message = "Your password was updated!"
                alert.addButtonWithTitle("OK")
                alert.show()
            } else {
                alert.title   = "Oops!"
                alert.message = "The new passwords don't match!"
                alert.addButtonWithTitle("OK")
                alert.show()
            }
        } else {
            alert.title   = "Oops!"
            alert.message = "You entered an incorrect password!"
            alert.addButtonWithTitle("OK")
            alert.show()
        }
    }

    @IBAction func doneUpdatingEmail(sender: AnyObject) {
        var old_eml = PFUser.currentUser().email as String
        var alert = UIAlertView()
        if (old_email.text == "\(old_eml)") {
            if (new_email.text == confirm_new_email.text) {
                PFUser.currentUser().email = new_email.text as String
                alert.title   = "Great!"
                alert.message = "Your email was updated!"
                alert.addButtonWithTitle("OK")
                alert.show()
            } else {
                alert.title   = "Oops!"
                alert.message = "The new emails don't match!"
                alert.addButtonWithTitle("OK")
                alert.show()
            }
        } else {
            alert.title   = "Oops!"
            alert.message = "You entered an incorrect email!"
            alert.addButtonWithTitle("OK")
            alert.show()
        }
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
