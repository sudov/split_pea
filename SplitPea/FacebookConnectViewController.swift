//
//  FacebookConnectViewController.swift
//  SplitPea
//
//  Created by Vinizzle on 1/10/15.
//  Copyright (c) 2015 OkraLabs. All rights reserved.
//

import UIKit

class FacebookConnectViewController: UIViewController, FBLoginViewDelegate {

    @IBOutlet var fbLoginView : FBLoginView!
    @IBOutlet var profilePictureView : FBProfilePictureView!
    
    func loginViewShowingLoggedInUser(loginView : FBLoginView!) {
        println("User Logged In")
        println("This is where you perform a segue.")
        storyboard?.instantiateViewControllerWithIdentifier("VenmoLoginViewController") as UIViewController
    }
    
    func loginViewFetchedUserInfo(loginView : FBLoginView!, user: FBGraphUser){
        println("User Name: \(user.name)")
        profilePictureView.profileID = user.objectID
        
        var storeFbId = PFObject(className: "UserInfo")
        storeFbId.setObject("\(user.name)", forKey: "FbName")
        storeFbId.saveInBackgroundWithBlock {
            (success: Bool!, error: NSError!) -> Void in
            if (success != nil) {
                NSLog("Object created with id: \(storeFbId.objectId)")
            } else {
                NSLog("%@", error)
            }
        }
        
        var url: NSURL = NSURL(string:"https://graph.facebook.com/(user.objectID)/picture?type=normal")!
        var request = NSURLRequest(URL:url)
        
    }
    
    func loginViewShowingLoggedOutUser(loginView : FBLoginView!) {
        println("User Logged Out")
    }
    
    func loginView(loginView : FBLoginView!, handleError:NSError) {
        println("Error: \(handleError.localizedDescription)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fbLoginView.delegate = self
        self.fbLoginView.readPermissions = ["public_profile", "email", "user_friends"]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
