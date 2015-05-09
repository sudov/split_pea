//
//  ExistingUserLogInViewController.swift
//  SplitPea
//
//  Created by Vinizzle on 4/20/15.
//  Copyright (c) 2015 OkraLabs. All rights reserved.
//

import UIKit

class ExistingUserLogInViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var userName: UITextField!
    
    @IBOutlet weak var passWord: UITextField!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.passWord.delegate = self;
        UIApplication.sharedApplication().statusBarStyle = .LightContent
    }

    func textFieldShouldReturn(passWord: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }

    @IBAction func logIn(sender: AnyObject) {
        var username = self.userName.text as String
        var password = self.passWord.text as String
        println("\(username)")
        PFUser.logInWithUsernameInBackground(username, password: password) {
            (user: PFUser!, error: NSError!) -> Void in
            if (error != nil) {
                var alertview = JSSAlertView().show(
                    self, // the parent view controller of the alert
                    title: "Incorrect Username/ Password!",
                    color: UIColor(red: (244.0/255.0), green: (63.0/255.0), blue: (79.0/255.0), alpha: 0.5),
                    iconImage: UIImage(named: "error.png")
                )
                alertview.setTitleFont("ClearSans-Bold")
                alertview.setTextFont("ClearSans")
                alertview.setButtonFont("ClearSans-Light")
                alertview.setTextTheme(.Light)
                
//                var alert = UIAlertController(title: "Error!", message: "Incorrect Username/ Password!", preferredStyle: UIAlertControllerStyle.Alert)
//                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
//                self.presentViewController(alert, animated: true, completion: nil)
            } else {
                self.performSegueWithIdentifier("existingUserLoggedIn", sender: self)
            }
        }
    }
    
    @IBAction func forgotPassword(sender: AnyObject) {
        var alert = UIAlertController(title: "Forgot Password?", message: "We will send you an E-mail with your password!", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addTextFieldWithConfigurationHandler {
            (textField: UITextField!) -> Void in
            textField.delegate = self
            textField.placeholder = "facebook e-mail"
        }
        alert.addAction(UIAlertAction(title: "Done", style: UIAlertActionStyle.Default, handler: {
            (action: UIAlertAction!) -> Void in
            var textfield: UITextField = alert.textFields?.first as! UITextField
            if (textfield.text.isEmpty == false) {
                println(textfield.text)
                PFUser.requestPasswordResetForEmail("\(textfield.text)")
            }
        }))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
