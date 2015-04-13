//
//  ViewController.swift
//  SplitPea
//
//  Created by Vinizzle on 8/20/14.
//  Copyright (c) 2014 OkraLabs. All rights reserved.
//

import UIKit
import AVFoundation
import MobileCoreServices

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    override func viewDidLoad() {

    }
    
    @IBAction func logIn(sender: AnyObject) {
        if (PFUser.currentUser() != nil) {
            self.performSegueWithIdentifier("loggedIn", sender: self)
        } else {
            var alert = UIAlertController(title: "Oops..", message: "You need to sign up first!", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
            alert.addAction(UIAlertAction(title: "Sign Up", style: .Default, handler: { action in
                //bleh  loggedIn
                self.performSegueWithIdentifier("signUp", sender: self)
            }))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func signUp(sender: AnyObject) {
        if (PFUser.currentUser() != nil) {
            var alert = UIAlertController(title: "Signed In", message: "You're already Signed Up!", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
            alert.addAction(UIAlertAction(title: "Log In", style: .Default, handler: { action in
                //bleh  loggedIn
                self.performSegueWithIdentifier("loggedIn", sender: self)
            }))
            self.presentViewController(alert, animated: true, completion: nil)
            
        } else {
            self.performSegueWithIdentifier("signUp", sender: self)
        }
    }
    
}

