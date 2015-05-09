//
//  ProfileViewController.swift
//  SplitPea
//
//  Created by Vinizzle on 1/10/15.
//  Copyright (c) 2015 OkraLabs. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.sharedApplication().statusBarStyle = .LightContent
    }

    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    @IBAction func forgotPasswordProfile(sender: AnyObject) {
        PFUser.requestPasswordResetForEmail("\(PFUser.currentUser().email)")
        var alertview = JSSAlertView().show(
            self, // the parent view controller of the alert
            title: "Your password has been sent to your email address!",
            color: UIColor(red: (244.0/255.0), green: (63.0/255.0), blue: (79.0/255.0), alpha: 0.5),
            iconImage: UIImage(named: "success.png")
        )
        alertview.setTitleFont("ClearSans-Bold")
        alertview.setTextFont("ClearSans")
        alertview.setButtonFont("ClearSans-Light")
        alertview.setTextTheme(.Light)
        
        
//        var alert = UIAlertController(title: "Success!", message: "Your password has been sent to your email address.", preferredStyle: UIAlertControllerStyle.Alert)
//        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
//        self.presentViewController(alert, animated: true, completion: nil)
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
