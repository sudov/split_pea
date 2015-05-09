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
    var checksArray: NSMutableArray!
    var checksTitleArray   = [String]()
    var checksPreviewArray = [UIImage]()
    @IBOutlet weak var currentChecksTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.sharedApplication().statusBarStyle = .LightContent

        SettingBar = SettingsBar(sourceView: self.view, menuItems: ["Profile", "Log Out"])
        SettingBar.delegate = self
        println(PFUser.currentUser().valueForKey("username"))
        var num = PFUser.currentUser().valueForKey("username") as! String
        var tel: NSNumber!
        let formatter = NSNumberFormatter()
        formatter.numberStyle = NSNumberFormatterStyle.DecimalStyle;
        if let number = formatter.numberFromString("\(num)") {
            println(number)
            tel = number
        }
        
//        let tel: NSNumber = (PFUser.currentUser().valueForKey("username") as! String).toInt()!
        PFUser.currentUser().setObject(tel, forKey: "phoneNumber")
        PFUser.currentUser().save()
        var id = PFUser.currentUser().objectId
        var query = PFQuery(className: "receiptData")
        query.whereKey("user_obj_id", containsString: id)
        
        var allReceipts = [PFObject]()
        allReceipts = query.findObjects() as! [PFObject]
        if allReceipts.count > 0 {
            for check in allReceipts {
                var img = ((check as PFObject).valueForKey("receiptImg") as! PFFile).getData()
                var title: AnyObject? = (check as PFObject).valueForKey("objectId")
                if let image = UIImage(data: img){
                    checksPreviewArray.append(image)
                }
                if let objID = (title as? String) {
                    checksTitleArray.append(objID)
                }
            }
        }
        
        currentChecksTable.delegate = self
        currentChecksTable.dataSource = self
        currentChecksTable.reloadData()
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
        var cell : CurrentChecksViewCell! = tableView.dequeueReusableCellWithIdentifier("currentChecksViewCell") as! CurrentChecksViewCell
        if(cell == nil)
        {
            cell = NSBundle.mainBundle().loadNibNamed("currentCheckCell", owner: self, options: nil)[0] as!CurrentChecksViewCell;
        }
        
        cell.tabTitle.text  =   "\(NSDate())"
        cell.tabPreview.image   =   checksPreviewArray[indexPath.row] as UIImage
        cell.accessoryType  =   UITableViewCellAccessoryType.DisclosureIndicator
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var id = checksTitleArray[indexPath.row] as String
        var query = PFQuery(className:"receiptData")
        var currentReceipt: PFObject = query.getObjectWithId(id) as PFObject
        currentReceipt.setObject(indexPath.row, forKey: "currentRow")
        currentReceipt.saveInBackgroundWithBlock {
            (success: Bool, error: NSError!) -> Void in
            if (success) {
//                self.performSegueWithIdentifier("showWhoPaid", sender: self)
            } else {
                NSLog("Cannot check this receipt out!", error!)
            }
        }
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            checksTitleArray.removeAtIndex(indexPath.row)
            checksPreviewArray.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
        }
    }
    
    func SettingsBarDidSelectButton(index: Int) {
        if index == 0 {
            self.performSegueWithIdentifier("goToProfile", sender: self)
        } else if index == 1 {
            PFUser.logOut()
            self.performSegueWithIdentifier("goToLanding", sender: self)
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
