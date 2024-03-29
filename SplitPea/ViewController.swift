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
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        if (PFUser.currentUser() != nil) {
            self.performSegueWithIdentifier("loggedIn", sender: self)
        }
        if (Venmo.sharedInstance().isSessionValid()) {
            var response: AutoreleasingUnsafeMutablePointer<NSURLResponse?>=nil
            var error: AutoreleasingUnsafeMutablePointer<NSError?> = nil
            var user_id = Venmo.sharedInstance().session.user.externalId
            var access_token = Venmo.sharedInstance().session.accessToken
            
            var url = NSURL(string: "https://api.venmo.com/v1/users/\(user_id)/friends?access_token=\(access_token)&limit=5000")
            var request = NSMutableURLRequest(URL: url!)
            request.HTTPMethod = "GET"
            request.timeoutInterval = 6.0
            
            var dataVal =  NSURLConnection.sendSynchronousRequest(request, returningResponse: response, error:nil)
            var jsonResult = NSJSONSerialization.JSONObjectWithData(dataVal!, options: NSJSONReadingOptions.MutableContainers, error: nil) as! NSDictionary
            
            if let reposArray = jsonResult["data"] as? [NSDictionary] {
                for item in reposArray {
//                    println(item)
                }
            }
            
        }
    }
    
    @IBAction func logIn(sender: AnyObject) {
        if (PFUser.currentUser() != nil) {
            self.performSegueWithIdentifier("loggedIn", sender: self)
        } else {
            self.performSegueWithIdentifier("oldUserLogIn", sender: self)
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
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
}

