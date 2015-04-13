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
    
//    func numberOfSectionsInTableView(tableView: UITableView) ->Int
//    {
//        return 1
//    }
//    
//    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return checksPreviewArray.count
//    }
//    
//    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        var cell : CurrentChecksViewCell! = tableView.dequeueReusableCellWithIdentifier("Cell") as CurrentChecksViewCell
//        if(cell == nil)
//        {
//            cell = NSBundle.mainBundle().loadNibNamed("Cell", owner: self, options: nil)[0] as CurrentChecksViewCell;
//        }
//        
//        cell.tabPreview.image   =   checksPreviewArray[indexPath.row] as? UIImage
//        cell.tabTitle.text      =   checksTitleArray[indexPath.row] as NSString
//        cell.isOwnerLabel.text  =   ownershipArray[indexPath.row] as NSString
//        
//        return cell
//    }
//    
//    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
//        return 50
//    }
//    
//    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        println("You selected cell #\(indexPath.row)!")
//    }
    
}
