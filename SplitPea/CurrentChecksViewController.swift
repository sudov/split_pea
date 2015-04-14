//
//  CurrentChecksViewController.swift
//  SplitPea
//
//  Created by Vinizzle on 1/8/15.
//  Copyright (c) 2015 OkraLabs. All rights reserved.
//

import UIKit

class CurrentChecksViewController: UIViewController, SettingsBarDelegate {
    
    var SettingBar: SettingsBar = SettingsBar()
    var checksPreviewArray: NSArray = []
    var checksTitleArray: NSArray   = []
    var ownershipArray: NSArray     = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SettingBar = SettingsBar(sourceView: self.view, menuItems: ["Profile", "Log Out"])
        SettingBar.delegate = self
        let tel: NSNumber = (PFUser.currentUser().valueForKey("username") as String).toInt()!
        PFUser.currentUser().setObject(tel, forKey: "phoneNumber")
        PFUser.currentUser().save()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func SettingsBarDidSelectButton(index: Int) {
        if index == 0 {
            let secondViewCotroller = storyboard?.instantiateViewControllerWithIdentifier("ProfileViewController") as ProfileViewController
            navigationController?.pushViewController(secondViewCotroller, animated: true)
        } else if index == 1 {
            let logOutViewCotroller = storyboard?.instantiateViewControllerWithIdentifier("vc") as ViewController
            navigationController?.pushViewController(logOutViewCotroller, animated: true)
            PFUser.logOut()
        }
    }
    
    @IBAction func openCloseSettingsBar() {
        SettingBar.openCloseSettingsBar()
    }
    
}
