//
//  AppDelegate.swift
//  SplitPea
//
//  Created by Vinizzle on 8/20/14.
//  Copyright (c) 2014 OkraLabs. All rights reserved.
//

import UIKit

@UIApplicationMain class AppDelegate: UIResponder, UIApplicationDelegate {
                            
    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        // [Optional] Power your app with Local Datastore. For more info, go to
        // https:// parse . com/docs/ios_guide#localdatastore/iOS
        Parse.enableLocalDatastore()
        
        // Initialize Parse.
        Parse.setApplicationId("XcV6BZJTOgbPDXtO2kZlXHiEtHV0uUqA5osXSElo", clientKey: "NhqnyGV52geB2cbNrFSm4c6jJSb04MsSgJz4nnun")
    
        FBLoginView.self
        FBProfilePictureView.self
        
        Venmo.startWithAppId("2234", secret:"pdFZMBrSczX4wHXVBvy49k9twUnSnJ4k", name:"SplitPea")
        
        let defaults = NSUserDefaults.standardUserDefaults()
        var has_launched: Bool? = defaults.valueForKey("hasLaunchedOnce") as? Bool
        if (has_launched == true) {
            // Don't do the wizard
        } else {
            // Run the Wizard
            defaults.setObject(true, forKey: "hasLaunchedOnce")
        }
        
        return true
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject?) -> Bool {
        
        var wasHandledFB:Bool = FBAppCall.handleOpenURL(url, sourceApplication: sourceApplication)
        
        var wasHandledVenmo:Bool = Venmo.sharedInstance().handleOpenURL(url)
        
//        if (wasHandledFB == true || wasHandledVenmo == true){
        if (wasHandledFB == true) {
            return true
        } else {
            return false
        }
    }

    func applicationWillResignActive(application: UIApplication!) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication!) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication!) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication!) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication!) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

