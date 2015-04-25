//
//  AddFriendsViewController.swift
//  SplitPea
//
//  Created by Vinizzle on 3/9/15.
//  Copyright (c) 2015 OkraLabs. All rights reserved.
//

import UIKit

class AddFriendsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.sharedApplication().statusBarStyle = .LightContent

        // Update List Of Friends
        var friendsRequest : FBRequest = FBRequest.requestForMyFriends()
        friendsRequest.startWithCompletionHandler{(connection:FBRequestConnection!, result:AnyObject!, error:NSError!) -> Void in
            var resultdict = result as! NSDictionary
            println("Result Dict: \(resultdict)")
            var data : NSArray = resultdict.objectForKey("data") as! NSArray
            
            for i in 0...data.count {
                let valueDict : NSDictionary = data[i]as! NSDictionary
                let id = valueDict.objectForKey("id") as! String
                println("the id value is \(id)")
            }
            
            var friends = resultdict.objectForKey("data") as! NSArray
            println("Found \(friends.count) friends")
        }
    }

    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
