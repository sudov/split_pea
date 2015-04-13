//
//  AddFriendsToItemViewController.swift
//  SplitPea
//
//  Created by Vinizzle on 4/2/15.
//  Copyright (c) 2015 OkraLabs. All rights reserved.
//

import UIKit

class AddFriendsToItemViewController: UIViewController {

    
    @IBOutlet weak var friendsForItem: UITableView!
    
    var friendPicsOnReceipt = [String]()
    var friendNamesOnReceipt = [String]()
    var friendIDsOnItem     = [String]()
    var friendsOnItem       = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var id = PFUser.currentUser().valueForKey("recentReceiptId") as NSString
        var query = PFQuery(className:"receiptData")
        var tabParticipants: PFObject! = query.getObjectWithId(id) as PFObject
        var picArray: NSArray! = tabParticipants.valueForKey("friendsOnReceipt") as NSArray
        
        for pic in picArray {
            friendPicsOnReceipt.append(pic as String)
            query = PFQuery(className:"User")
            query.whereKey("picture", equalTo: pic as String)
            println("on 1")
            println(pic as String)
            
            var user: NSArray!
            var response: Void = query.findObjectsInBackgroundWithBlock {
                (object: [AnyObject]!, err: NSError!) -> Void in
                if (object != nil) {
                    println(object)
                    user = object
                } else {
                    println("k nothing came back")
                }
            }

            if user != nil {
                println(user)
                friendIDsOnItem.append(user[0].valueForKey("phoneNumber") as String)
                friendNamesOnReceipt.append(user[0].valueForKey("displayName") as String)
            }
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friendNamesOnReceipt.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell : AddFriendToItemViewCell! = tableView.dequeueReusableCellWithIdentifier("friendForItemCell") as AddFriendToItemViewCell
        cell.accessoryType = .None
        cell.itemFriendName?.text = friendNamesOnReceipt[indexPath.row]
        cell.itemFriendPic?.profileID = friendPicsOnReceipt[indexPath.row]
        var width: CGFloat! = cell.itemFriendPic?.frame.size.width
        cell.itemFriendPic?.layer.cornerRadius = (width / 2)
        cell.itemFriendPic?.clipsToBounds = true
        
        return cell;
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell: AddFriendToItemViewCell! = tableView.cellForRowAtIndexPath(indexPath) as AddFriendToItemViewCell
        
        if (cell?.accessoryType == UITableViewCellAccessoryType.Checkmark) {
            cell?.accessoryType = .None
            for index in 0...friendIDsOnItem.count {
                if friendIDsOnItem[index] == "\(cell.itemFriendName?.text)" {
                    friendIDsOnItem.removeAtIndex(index)
                    break
                }
            }
        } else {
            cell?.accessoryType = .Checkmark
            if contains(friendIDsOnItem, "\(cell.itemFriendName?.text)") == false {
                friendIDsOnItem.append("\(cell.itemFriendName?.text)")
            }
        }
    }
    
    func tableView(tableView: UITableView, sectionForSectionIndexTitle title: String, atIndex index: Int) -> Int {
        return friendNamesOnReceipt.count
    }
    

    @IBAction func returnToItemVC(sender: AnyObject) {
        var id = PFUser.currentUser().valueForKey("recentReceiptId") as NSString
        var query = PFQuery(className: "receiptData")
        var updateObj: PFObject! = query.getObjectWithId(id) as PFObject
        updateObj.setObject(friendIDsOnItem, forKey: "currentRowFriends")
        updateObj.save()
        self.performSegueWithIdentifier("returnToItemVCont", sender: self)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
