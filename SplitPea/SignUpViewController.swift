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
        UIApplication.sharedApplication().statusBarStyle = .LightContent
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(userPassword: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    @IBAction func addUserToDB(sender: AnyObject) {
        if (userPhone.text != "" && userPassword.text != "") {
            var user = PFUser()
            user.username = userPhone.text
            user.password = userPassword.text
            user.signUpInBackgroundWithBlock ({
                (succeeded: Bool, error: NSError?) -> Void in
                if error == nil {
                    self.performSegueWithIdentifier("signUpWithFB", sender: self)
                }
            })
            user.pin()
            
        } else {
            PFUser.requestPasswordResetForEmail("\(PFUser.currentUser().email)")
            var alertview = JSSAlertView().show(
                self, // the parent view controller of the alert
                title: "Either your username isn't a valid US number or you haven't entered a password!",
                color: UIColor(red: (244.0/255.0), green: (63.0/255.0), blue: (79.0/255.0), alpha: 0.5),
                iconImage: UIImage(named: "error.png")
            )
            alertview.setTitleFont("ClearSans-Bold")
            alertview.setTextFont("ClearSans")
            alertview.setButtonFont("ClearSans-Light")
            alertview.setTextTheme(.Light)
            
//            var alert = UIAlertController(title: "Oops..", message: "Either your username isn't a valid US number or you haven't entered a password!", preferredStyle: UIAlertControllerStyle.Alert)
//            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
        }
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
}
