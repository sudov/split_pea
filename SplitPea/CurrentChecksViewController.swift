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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SettingBar = SettingsBar(sourceView: self.view, menuItems: ["Profile", "Log Out"])
        SettingBar.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func SettingsBarDidSelectButton(index: Int) {
        if index == 0 {
            println("Woo profile")
            let secondViewCotroller = storyboard?.instantiateViewControllerWithIdentifier("ProfileViewController") as ProfileViewController
            self.navigationController?.pushViewController(secondViewCotroller, animated: true)            
//            navigationController?.pushViewController(ProfileViewController.self(), animated: true)
        } else if index == 1 {
            println("Don't leave")
        }
    }
    
    @IBAction func openCloseSettingsBar() {
        SettingBar.openCloseSettingsBar()
    }
    
}
