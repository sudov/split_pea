//
//  ItemViewController.swift
//  SplitPea
//
//  Created by Vinizzle on 1/2/15.
//  Copyright (c) 2015 OkraLabs. All rights reserved.
//

import UIKit
import CoreData

class ItemViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var jsonResult: AnyObject = [:];
    var currentPics: AnyObject = [:];
    var friendProfilePics   = [String]()
    var itemsAndFriends     = Array(count: 50, repeatedValue: [String]())
    
    // Receipt Content Data Structures
    var itemArray: NSMutableArray!
    var costArray: NSMutableArray!
    var numItems: NSMutableArray!
    var subTotalCoreData: NSString!
    var taxCoreData: NSString!
    var finalTotalCoreData: NSString!
    
    @IBOutlet weak var subTotal: UILabel!
    @IBOutlet weak var tax: UILabel!
    @IBOutlet weak var finalTotal: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var listOfFriendsInTab: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        Update friends pics
        var id = PFUser.currentUser().valueForKey("recentReceiptId") as NSString
        var query = PFQuery(className:"receiptData")
        var picArray: NSArray = query.getObjectWithId(id).valueForKey("friendsOnReceipt") as NSArray
        
        if picArray.count == 0 {
//            println("WAI YU DO DISS?")
        } else {
            for pic in picArray {
                println(pic as String)
                friendProfilePics.append(pic as String)
            }
        }
        
//        Register TableView Cells
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
//        Register CollectionViewCells
        self.listOfFriendsInTab!.registerClass(FriendsCollectionViewCell.self, forCellWithReuseIdentifier: "FriendsCollectionViewCell")
        self.listOfFriendsInTab.dataSource = self
        self.listOfFriendsInTab.delegate   = self
        
//        Grab receipt JSON from Parse
        query = PFQuery(className:"receiptData")
        jsonResult = query.getObjectWithId(id)["data"]
        itemArray       =   jsonResult.valueForKey("item") as NSMutableArray
        costArray       =   jsonResult.valueForKey("cost") as NSMutableArray
        numItems        =   jsonResult.valueForKey("num_item_array") as NSMutableArray
        subTotalCoreData    =   jsonResult["sub-total"] as NSString
        taxCoreData     =   jsonResult["tax"] as NSString
        finalTotalCoreData  = jsonResult["final_total"] as NSString
        
        subTotal.text   =   subTotalCoreData
        tax.text        =   taxCoreData
        finalTotal.text =   finalTotalCoreData
        
    }
    
    //    TableView to show Itemized Receipt
    func numberOfSectionsInTableView(tableView: UITableView) ->Int
    {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell : ItemViewCell! = tableView.dequeueReusableCellWithIdentifier("Cell") as ItemViewCell
        if(cell == nil)
        {
            cell = NSBundle.mainBundle().loadNibNamed("Cell", owner: self, options: nil)[0] as ItemViewCell;
        }
        
        cell.item.text          =   itemArray?[indexPath.row] as NSString
        cell.item_amount.text   =   costArray?[indexPath.row] as NSString
        cell.quantity.text      =   numItems?[indexPath.row] as NSString
//        cell.accessoryType      =   UITableViewCellAccessoryType.DetailButton
        cell.accessoryType      =   UITableViewCellAccessoryType.DisclosureIndicator
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var id = PFUser.currentUser().valueForKey("recentReceiptId") as NSString
        var query = PFQuery(className:"receiptData")
        var currentReceipt: PFObject = query.getObjectWithId(id) as PFObject
        currentReceipt.setObject(indexPath.row, forKey: "currentRow")
        currentReceipt.saveInBackgroundWithBlock {
            (success: Bool!, error: NSError!) -> Void in
            if (success != nil) {
                self.performSegueWithIdentifier("testSegue", sender: self)
            } else {
            }
        }
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            
            itemArray.removeObjectAtIndex(indexPath.row)
            costArray.removeObjectAtIndex(indexPath.row)
            numItems.removeObjectAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
        }
    }
    
    //    Collection View To show Friends in Tab
    func numberOfSectionsInCollectionView(listOfFriendsInTab: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(listOfFriendsInTab: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return friendProfilePics.count
    }
    
    func collectionView(listOfFriendsInTab: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = listOfFriendsInTab.dequeueReusableCellWithReuseIdentifier("FriendsCollectionViewCell", forIndexPath: indexPath) as FriendsCollectionViewCell
        
        if friendProfilePics.count > 0 {
            var itemViewFriendPic:UIImageView = UIImageView()
            itemViewFriendPic.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
            itemViewFriendPic.center = cell.center
            
            var accessToken = FBSession.activeSession().accessTokenData.accessToken as String
            var str = "https://graph.facebook.com/\(friendProfilePics[indexPath.row] as String)/picture?type=large&return_ssl_resources=1&access_token=\(accessToken)"
            let url = NSURL(string: str)
            let urlRequest = NSURLRequest(URL: url!)
            NSURLConnection.sendAsynchronousRequest(urlRequest, queue: NSOperationQueue.mainQueue()) { (response:NSURLResponse!, data:NSData!, error:NSError!) -> Void in
                    // Display the image
                    let image = UIImage(data: data)
                    itemViewFriendPic.image = image
                }
            var width: CGFloat! = itemViewFriendPic.frame.size.width
            itemViewFriendPic.layer.cornerRadius = (width / 2)
            itemViewFriendPic.clipsToBounds = true
            
            cell.addSubview(itemViewFriendPic)
        }
        
        return cell
    }
    
    func collectionView(listOfFriendsInTab: UICollectionView!, didSelectItemAtIndexPath indexPath: NSIndexPath!) {
//        println("Drag and Drop coming soon.")
    }
    
    @IBAction func Charged(sender: AnyObject) {
        var id = PFUser.currentUser().valueForKey("recentReceiptId") as NSString
        var query = PFQuery(className:"receiptData")
        var currentReceipt: PFObject = query.getObjectWithId(id) as PFObject
        currentReceipt.setObject(tableView.indexPathForSelectedRow()?.length, forKey: "itemCount")
        var boolArrLen = 0
        if tableView.indexPathForSelectedRow()?.length > 0 {
            boolArrLen = tableView.indexPathForSelectedRow()?.length as Int!
        }
        var statusArray = [Bool](count: boolArrLen, repeatedValue: false)
        currentReceipt.setObject(statusArray, forKey: "statusArray")
        
//        Notify User Charging is Complete
        let alert = UIAlertController(title: "", message: "You're friends have been charged!", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
}
