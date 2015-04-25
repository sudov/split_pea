//
//  CurrentChecksViewController.swift
//  SplitPea
//
//  Created by Vinizzle on 1/8/15.
//  Copyright (c) 2015 OkraLabs. All rights reserved.
//

import UIKit

class CurrentChecksViewController: UIViewController, SettingsBarDelegate, UITableViewDataSource, UITableViewDelegate {
    
    var SettingBar: SettingsBar = SettingsBar()
    var checksPreviewArray: NSMutableArray!
    var checksArray: NSMutableArray!
    var checksTitleArray: NSMutableArray!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.sharedApplication().statusBarStyle = .LightContent

        SettingBar = SettingsBar(sourceView: self.view, menuItems: ["Profile", "Log Out"])
        SettingBar.delegate = self
        let tel: NSNumber = (PFUser.currentUser().valueForKey("username") as! String).toInt()!
        PFUser.currentUser().setObject(tel, forKey: "phoneNumber")
        PFUser.currentUser().save()
        var id = PFUser.currentUser().objectId
        var query = PFQuery(className: "receiptData")
        query.whereKey("user_obj_id", containsString: id)
        var allReceipts = query.findObjects()
        if let allReceipts: NSArray = query.findObjects() {
            checksArray = allReceipts.mutableCopy() as! NSMutableArray
        }
        for check in checksArray {
//            checksTitleArray.addObject(check.objectId as String)
//            checksPreviewArray.addObject(check.valueForKey("receiptImg") as! UIImage)
        }
    }
    
//    TableView to show Scanned Receipts
    func numberOfSectionsInTableView(tableView: UITableView) ->Int
    {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return checksTitleArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell : CurrentChecksViewCell! = tableView.dequeueReusableCellWithIdentifier("currentCheckCell") as! CurrentChecksViewCell
        if(cell == nil)
        {
            cell = NSBundle.mainBundle().loadNibNamed("currentCheckCell", owner: self, options: nil)[0] as!CurrentChecksViewCell;
        }
        
        cell.tabTitle.text  =   checksTitleArray[indexPath.row] as? String
//        cell.tabPreview.image   =   checksPreviewArray[indexPath.row] as UIImage
        cell.accessoryType  =   UITableViewCellAccessoryType.DisclosureIndicator
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        var id = PFUser.currentUser().valueForKey("recentReceiptId") as NSString
//        var query = PFQuery(className:"receiptData")
//        var currentReceipt: PFObject = query.getObjectWithId(id) as PFObject
//        currentReceipt.setObject(indexPath.row, forKey: "currentRow")
//        currentReceipt.saveInBackgroundWithBlock {
//            (success: Bool!, error: NSError!) -> Void in
//            if (success != nil) {
//                self.performSegueWithIdentifier("testSegue", sender: self)
//            } else {
//            }
//        }
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            checksTitleArray.removeObjectAtIndex(indexPath.row)
            checksPreviewArray.removeObjectAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
        }
    }
    
    func SettingsBarDidSelectButton(index: Int) {
        if index == 0 {
            let secondViewCotroller = storyboard?.instantiateViewControllerWithIdentifier("ProfileViewController") as! ProfileViewController
            navigationController?.pushViewController(secondViewCotroller, animated: true)
        } else if index == 1 {
            let logOutViewCotroller = storyboard?.instantiateViewControllerWithIdentifier("vc") as! ViewController
            navigationController?.pushViewController(logOutViewCotroller, animated: true)
            PFUser.logOut()
        }
    }
    
    @IBAction func openCloseSettingsBar() {
        SettingBar.openCloseSettingsBar()
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
