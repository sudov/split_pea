//
//  TableViewController.swift
//  SplitPea
//
//  Created by Vinizzle on 1/8/15.
//  Copyright (c) 2015 OkraLabs. All rights reserved.
//

import UIKit

protocol SettingsTableViewControllerDelegate {
    func SettingsTableDidSelectRow(indexPath: NSIndexPath)
}

class SettingsTableViewController: UITableViewController {
    
    var delegate: SettingsTableViewControllerDelegate?
    var tableViewData: Array<String> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.sharedApplication().statusBarStyle = .LightContent
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewData.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:UITableViewCell? = tableView.dequeueReusableCellWithIdentifier("Cell") as? UITableViewCell
        
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "Cell")
            // Configure the cell...
            cell!.backgroundColor = UIColor(red: 0.004, green: 0.596, blue: 0.459, alpha: 1.0)
            cell!.textLabel?.textColor = UIColor.whiteColor()
            
            let selectedView:UIView = UIView(frame: CGRect(x: 0, y: 0, width: cell!.frame.size.width, height: cell!.frame.size.height))
            selectedView.backgroundColor = UIColor(red: 0.161, green: 0.671, blue: 0.529, alpha: 1.0)
            
            cell!.selectedBackgroundView = selectedView
        }
        
        cell!.textLabel?.text = tableViewData[indexPath.row]
        
        return cell!
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 45.0
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        delegate?.SettingsTableDidSelectRow(indexPath)
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
}
