//
//  AddFriendsToItemViewController.swift
//  SplitPea
//
//  Created by Vinizzle on 4/2/15.
//  Copyright (c) 2015 OkraLabs. All rights reserved.
//

import UIKit

class AddFriendsToItemViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var friendsForItem: UITableView!
    
    var friendPicsOnReceipt  = [String]()
    var friendNamesOnReceipt = [String]()
    var friendIDsOnReceipt   = [String]()
    var friendIDsOnItem      = [String]()
    var friendsOnItem        = [String]()
    var friendDict = [String: String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var id = PFUser.currentUser().valueForKey("recentReceiptId") as! NSString
        var query = PFQuery(className:"receiptData")
        var tabParticipants: PFObject! = query.getObjectWithId(id as String) as PFObject
        var picArray: NSArray! = tabParticipants.valueForKey("friendsOnReceipt") as! NSArray

        
        var userNumber: String!
        var userName:   String!
        var userPic:    String!
        
        for pic in picArray {
            query = PFUser.query()// PFQuery(className: "User")
            query.whereKey("picture", containsString: (pic as! String))
            var temp = query.findObjects()
            userNumber = (temp[0] as! PFObject).valueForKey("username") as! String
            userName   = (temp[0] as! PFObject).valueForKey("displayName") as! String
            userPic    = (temp[0] as! PFObject).valueForKey("picture") as! String
            
            if userNumber != nil {
                friendIDsOnReceipt.append(userNumber)
                friendNamesOnReceipt.append(userName)
                friendPicsOnReceipt.append(userPic)
                friendDict[userName as String] = userNumber as String
            }
        }
        
        friendsForItem.dataSource = self
        friendsForItem.delegate = self
        friendsForItem.reloadData()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friendNamesOnReceipt.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell : AddFriendToItemViewCell! = tableView.dequeueReusableCellWithIdentifier("addFriendToItemCell") as! AddFriendToItemViewCell
        cell.itemFriendName?.text = friendNamesOnReceipt[indexPath.row]
        cell.itemFriendPic?.profileID = friendPicsOnReceipt[indexPath.row]
        var width: CGFloat! = cell.itemFriendPic?.frame.size.width
        cell.itemFriendPic?.layer.cornerRadius = (width / 2)
        cell.itemFriendPic?.clipsToBounds = true
        cell.accessoryType = .None
        
        return cell;
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell: AddFriendToItemViewCell! = tableView.cellForRowAtIndexPath(indexPath) as! AddFriendToItemViewCell
        
        if (cell?.accessoryType == UITableViewCellAccessoryType.Checkmark) {
            cell?.accessoryType = .None
            for index in 0...friendsOnItem.count {
                if friendsOnItem[index] == "\(cell.itemFriendName?.text)" {
                    friendsOnItem.removeAtIndex(index)
                    friendIDsOnItem.removeAtIndex(index)
                    break
                }
            }
        } else {
            cell?.accessoryType = .Checkmark
            var nameToBeAdded: String!
            nameToBeAdded = cell.itemFriendName?.text
            println(nameToBeAdded as String)
            friendIDsOnItem.append(friendDict[nameToBeAdded as String]!)
        }
    }
    
    @IBAction func returnToItemVC(sender: AnyObject) {
        var id = PFUser.currentUser().valueForKey("recentReceiptId") as! NSString
        var query = PFQuery(className: "receiptData")
        var updateObj: PFObject! = query.getObjectWithId(id as String) as PFObject
        
        var current_row: Int = updateObj.valueForKey("currentRow") as! Int
        var friendsPerItem: [[String]]
        
        if (updateObj.valueForKey("friendsPerItem") != nil) {
            friendsPerItem = updateObj.valueForKey("friendsPerItem") as! [[String]]
            friendsPerItem[current_row] = friendIDsOnItem
        } else {
            println("Was Nil")
            friendsPerItem = Array(count: 50, repeatedValue: [String]())
            friendsPerItem[current_row] = friendIDsOnItem
        }
        updateObj.setObject(friendsPerItem, forKey: "friendsPerItem")
        updateObj.saveInBackgroundWithBlock ({
            (success: Bool, error: NSError?) -> Void in
            if (success) {
                self.performSegueWithIdentifier("returnToItemVCont", sender: self)
            } else {
                println("Saving user to item failed.")
            }
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
