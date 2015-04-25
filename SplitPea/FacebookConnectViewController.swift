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
        self.performSegueWithIdentifier("signUpWithVenmo", sender: self)
    }
    
    func loginViewFetchedUserInfo(loginView : FBLoginView!, user: FBGraphUser){
        // Verify
        profilePictureView.profileID = user.objectID
        
        // Update Parse with FB info
        PFUser.currentUser().setObject(user.name, forKey: "displayName")
        PFUser.currentUser().setObject(user.objectID, forKey: "picture")

        var email = user.objectForKey("email") as! String
        PFUser.currentUser().setObject(email, forKey: "email")
        PFUser.currentUser().save()
        
        // Get List Of Friends
        var friendsRequest : FBRequest = FBRequest.requestForMyFriends()
        friendsRequest.startWithCompletionHandler{(connection:FBRequestConnection!, result:AnyObject!, error:NSError!) -> Void in
            var resultdict = result as! NSDictionary
//            println("Result Dict: \(resultdict)")
            var data : NSArray = resultdict.objectForKey("data") as! NSArray
            
            for i in 0...data.count {
                let valueDict : NSDictionary = data[i] as! NSDictionary
                let id = valueDict.objectForKey("id") as! String
//                println("the id value is \(id)")
            }
            
            var friends = resultdict.objectForKey("data") as! NSArray
//            println("Found \(friends.count) friends")
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
        UIApplication.sharedApplication().statusBarStyle = .LightContent
    }

    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
