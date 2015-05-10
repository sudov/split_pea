//
//  ItemViewController.swift
//  SplitPea
//
//  Created by Vinizzle on 1/2/15.
//  Copyright (c) 2015 OkraLabs. All rights reserved.
//

import UIKit
import CoreData

class ItemViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIPickerViewDelegate {
    
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
    var tip_values = ["15%","18%","21%","25%"]
    var finalTip: Float!
    
//    @IBOutlet weak var subTotal: UILabel!
//    @IBOutlet weak var tax: UILabel!
    
    @IBOutlet weak var subTotal: UITextField!
    @IBOutlet weak var tax: UITextField!
    
    @IBOutlet weak var finalTotal: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var listOfFriendsInTab: UICollectionView!
    @IBOutlet weak var tipList: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        var id = PFUser.currentUser().valueForKey("recentReceiptId") as! NSString
        var query = PFQuery(className:"receiptData")
        var data_object: PFObject = query.getObjectWithId(id as String) as PFObject

//        Update friends pics
        var picArray: NSArray = data_object.valueForKey("friendsOnReceipt") as! NSArray
        
        if picArray.count > 0 {
            for pic in picArray {
                friendProfilePics.append(pic as! String)
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
        
        self.tipList!.registerClass(TipViewCell.self, forCellWithReuseIdentifier: "tip_cell")
        self.tipList.dataSource = self
        self.tipList.delegate = self
        
        var shouldUpload: Bool = data_object.valueForKey("first") as! Bool
        if (shouldUpload) {
//            Grab receipt JSON from Parse
            query = PFQuery(className:"receiptData")
            jsonResult = query.getObjectWithId(id as String)["data"]
            itemArray       =   jsonResult.valueForKey("item") as! NSMutableArray
            costArray       =   jsonResult.valueForKey("cost") as! NSMutableArray
            numItems        =   jsonResult.valueForKey("num_item_array") as! NSMutableArray
            subTotalCoreData    =   jsonResult["sub-total"] as! String
            taxCoreData     =   jsonResult["tax"] as! String
            finalTotalCoreData  = jsonResult["final_total"] as! String
            
            data_object.setObject(costArray, forKey: "costArray")
            data_object.setObject(itemArray, forKey: "itemArray")
            data_object.setObject(numItems, forKey: "numItemsArray")
            data_object.setObject(taxCoreData as String, forKey: "tax")
            data_object.setObject(subTotalCoreData as String, forKey: "subTotal")
            data_object.setObject(finalTotalCoreData as String, forKey: "finalTotal")
            data_object.setObject(false, forKey: "first")
            data_object.saveInBackgroundWithBlock ({
                (success: Bool, error: NSError?) -> Void in
                if (success) {
                    NSLog("Cost, Item and Number Arrays Uploaded!")
                } else {
                    NSLog("FAILURE!!: Cost, Item and Number Arrays Not Uploaded!", error!)
                }
            })
        } else {
            itemArray = data_object.valueForKey("itemArray") as! NSMutableArray
            costArray = data_object.valueForKey("costArray") as! NSMutableArray
            numItems  = data_object.valueForKey("numItemsArray") as! NSMutableArray
            taxCoreData         = data_object.valueForKey("tax") as! String
            subTotalCoreData    = data_object.valueForKey("subTotal") as! String
            finalTotalCoreData  = data_object.valueForKey("finalTotal") as! String
            
        }
        
        //subTotal.text   =   subTotalCoreData as String
        //self.subTotal.delegate = self
        tax.text        =   taxCoreData as String
        tax.textAlignment = NSTextAlignment.Center
        tax.textColor   =   UIColor.whiteColor()
        self.tax.delegate = self
        //finalTotal.text =   finalTotalCoreData as String
        
        tipList.delaysContentTouches = true
        finalTip = 0
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.tax.endEditing(true)
        return false
//        if (textField == subTotal) {
//            self.subTotal.endEditing(true)
//            return false
//        } else  {
//            self.tax.endEditing(true)
//            return false
//        }
    }
    
//    @IBAction func subTotalChanged(sender: AnyObject) {
//        subTotalCoreData = subTotal.text as String
//        var id = PFUser.currentUser().valueForKey("recentReceiptId") as! NSString
//        var query = PFQuery(className:"receiptData")
//        var data_object: PFObject = query.getObjectWithId(id as String) as PFObject
//        data_object.setObject(subTotalCoreData, forKey: "subTotal")
//        data_object.save()
//    }
    
    @IBAction func taxChanged(sender: AnyObject) {
        taxCoreData = tax.text as String
        var id = PFUser.currentUser().valueForKey("recentReceiptId") as! NSString
        var query = PFQuery(className:"receiptData")
        var data_object: PFObject = query.getObjectWithId(id as String) as PFObject
        data_object.setObject(taxCoreData, forKey: "tax")
        data_object.save()
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
        var cell : ItemViewCell! = tableView.dequeueReusableCellWithIdentifier("Cell") as! ItemViewCell
        if(cell == nil)
        {
            cell = NSBundle.mainBundle().loadNibNamed("Cell", owner: self, options: nil)[0] as! ItemViewCell;
        }

        cell.item.text          =   itemArray?[indexPath.row]  as? String
        cell.item_amount.text   =   costArray?[indexPath.row] as! String
        cell.quantity.text      =   numItems?[indexPath.row] as! String
        cell.accessoryType      =   UITableViewCellAccessoryType.DisclosureIndicator
        
        var id = PFUser.currentUser().valueForKey("recentReceiptId") as! NSString
        var query = PFQuery(className:"receiptData")
        var currentReceipt: PFObject = query.getObjectWithId(id as String) as PFObject
        
        let friendsPerItem: AnyObject? = currentReceipt.valueForKey("friendsPerItem") as AnyObject?
        if let latest = friendsPerItem as? [[String]]  {
            if (latest[indexPath.row].count > 0) {
                cell.backgroundColor = UIColor(red: (67.0/255.0), green: (180.0/255.0), blue: (112.0/255.0), alpha: 0.75)
            } else {
                cell.backgroundColor = UIColor.whiteColor()
            }
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var id = PFUser.currentUser().valueForKey("recentReceiptId") as! NSString
        var query = PFQuery(className:"receiptData")
        var currentReceipt: PFObject = query.getObjectWithId(id as String) as PFObject
        currentReceipt.setObject(indexPath.row, forKey: "currentRow")
        currentReceipt.saveInBackgroundWithBlock ({
            (success: Bool, error: NSError?) -> Void in
            if (success) {
                self.performSegueWithIdentifier("testSegue", sender: self)
            } else {
            }
        })
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            itemArray.removeObjectAtIndex(indexPath.row)
            costArray.removeObjectAtIndex(indexPath.row)
            numItems.removeObjectAtIndex(indexPath.row)
            
            var id = PFUser.currentUser().valueForKey("recentReceiptId") as! NSString
            var query = PFQuery(className:"receiptData")
            var uplCostArray: PFObject = query.getObjectWithId(id as String) as PFObject
            uplCostArray.setObject(costArray, forKey: "costArray")
            uplCostArray.setObject(itemArray, forKey: "itemArray")
            uplCostArray.setObject(numItems, forKey: "numItemsArray")
            uplCostArray.saveInBackgroundWithBlock ({
                (success: Bool, error: NSError?) -> Void in
                if (success) {
                    NSLog("Cost, Item and Number Arrays Updated!")
                } else {
                    NSLog("FAILURE!!: Cost, Item and Number Arrays Not Updated!", error!)
                }
            })
            
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
        }
    }
    
    //    Collection View To show Friends in Tab
    func numberOfSectionsInCollectionView(listOfFriendsInTab: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (collectionView == listOfFriendsInTab) {
            return friendProfilePics.count
        } else {
            return tip_values.count
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if (collectionView == listOfFriendsInTab) {
            let cell = listOfFriendsInTab.dequeueReusableCellWithReuseIdentifier("FriendsCollectionViewCell", forIndexPath: indexPath) as! FriendsCollectionViewCell
        
            if friendProfilePics.count > 0 {
                var itemViewFriendPic:UIImageView = UIImageView()
                itemViewFriendPic.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
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
            self.tableView.reloadData()
            return cell
        } else {
            let cell = tipList.dequeueReusableCellWithReuseIdentifier("tip_cell", forIndexPath: indexPath) as! TipViewCell
            var newLabel = UILabel(frame: CGRectMake(0, 0, 85.0, 45.0))
            newLabel.text = tip_values[indexPath.row]
            newLabel.textAlignment = NSTextAlignment.Center
            
            if (cell.selected) {
                cell.backgroundColor = UIColor.whiteColor()
                newLabel.textColor   = UIColor(red: (67.0/255.0), green: (180.0/255.0), blue: (112.0/255.0), alpha: 1.0)

            } else {
                cell.backgroundColor = UIColor(red: (67.0/255.0), green: (180.0/255.0), blue: (112.0/255.0), alpha: 1.0)
                newLabel.textColor   = UIColor.whiteColor()
            }
            
            cell.addSubview(newLabel)
            self.tableView.reloadData()
            return cell
        }
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if (collectionView == tipList) {
            let cell = self.tipList.cellForItemAtIndexPath(indexPath)
            cell?.backgroundColor = UIColor.whiteColor()
            var newLabel = UILabel(frame: CGRectMake(0, 0, 85.0, 45.0))
            newLabel.text = tip_values[indexPath.row]
            newLabel.textColor   = UIColor(red: (67.0/255.0), green: (180.0/255.0), blue: (112.0/255.0), alpha: 1.0)
            newLabel.textAlignment = NSTextAlignment.Center
            cell?.addSubview(newLabel)
            finalTip = (tip_values[indexPath.row] as NSString).floatValue
        }
    }
    
    func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        let cell = self.tipList.cellForItemAtIndexPath(indexPath)
        cell?.backgroundColor = UIColor(red: (67.0/255.0), green: (180.0/255.0), blue: (112.0/255.0), alpha: 1.0)
        var newLabel = UILabel(frame: CGRectMake(0, 0, 85.0, 45.0))
        newLabel.text = tip_values[indexPath.row]
        newLabel.textColor   = UIColor.whiteColor()
        newLabel.textAlignment = NSTextAlignment.Center
        cell?.addSubview(newLabel)
    }
    
    func collectionView(collectionView: UICollectionView, didUnhighlightItemAtIndexPath indexPath: NSIndexPath) {

    }
    @IBAction func Charged(sender: AnyObject) {
        var id = PFUser.currentUser().valueForKey("recentReceiptId") as! NSString
        var query = PFQuery(className:"receiptData")
        var currentReceipt: PFObject = query.getObjectWithId(id as String) as PFObject
        
        var itemCount = 0
        
        if let friends_per_item = currentReceipt.valueForKey("friendsPerItem") as? [[String]] {
            for index in 0...friends_per_item.count {
                if friends_per_item[index].isEmpty && index > costArray.count {
                    break
                }
                itemCount = itemCount + 1
            }
            currentReceipt.setObject(itemCount, forKey: "itemCount")
            var statusArr = [Bool](count: itemCount, repeatedValue: false)
            currentReceipt.setObject(statusArr, forKey: "statusArray")
            currentReceipt.save()
            println("This is the final Tip")
            finalTip = finalTip/100
            println("\(finalTip)")
            finalTip = finalTip/Float(itemCount)
            
//            Charge Friends
            chargeFriends()
            println("Step 1")
//            Notify User Charging is Complete
            let alert = UIAlertController()
            alert.title = "Success!"
            alert.message = "Your friends have been charged!"
            println("Step 2")
            var okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) {
                UIAlertAction in
                NSLog("Done Splitting")
                println("Step 3")
                self.performSegueWithIdentifier("doneSplitting", sender: self)
            }
            alert.addAction(okAction)
            self.presentViewController(alert, animated: true, completion: nil)
        } else {
            var alertview = JSSAlertView().show(
                self, // the parent view controller of the alert
                title: "Assign items to friends!",
                color: UIColor(red: (244.0/255.0), green: (63.0/255.0), blue: (79.0/255.0), alpha: 0.5),
                iconImage: UIImage(named: "error.png")
            )
            alertview.setTitleFont("ClearSans-Bold")
            alertview.setTextFont("ClearSans")
            alertview.setButtonFont("ClearSans-Light")
            alertview.setTextTheme(.Light)
        }
    }
    
    func chargeFriends() {
        var id = PFUser.currentUser().valueForKey("recentReceiptId") as! NSString
        var query = PFQuery(className:"receiptData")
        var currentReceipt: PFObject = query.getObjectWithId(id as String) as PFObject
        
        Venmo.sharedInstance().refreshTokenWithCompletionHandler {
            (token: String!, success: Bool, error: NSError!) -> Void in
                var amount   = "0.01"
                var message  = "split_all_the_peas"
                var audience = "private"
                var atoken    = Venmo.sharedInstance().session.accessToken
                Venmo.sharedInstance().defaultTransactionMethod = VENTransactionMethod.API
                
                var index = 0
                var person_list: [[String]] = currentReceipt.valueForKey("friendsPerItem") as! [[String]]
                for item in person_list {
                    if index >= self.costArray.count {
                        break
                    }
                    
                    var item_cost = ((self.costArray[index] as! NSString).floatValue/Float(item.count))
                    item_cost = item_cost + self.taxCoreData.floatValue/Float(item.count)
                    item_cost = item_cost + self.finalTip * item_cost
                    item_cost = item_cost + self.taxCoreData.floatValue/Float(self.itemArray.count)
                    amount = "-\(item_cost)"

                    for phone_number in item {
                        var phone: String = phone_number as String
                        
                        var response: AutoreleasingUnsafeMutablePointer<NSURLResponse?>=nil
                        var error: AutoreleasingUnsafeMutablePointer<NSError?> = nil
                        var url_str = "https://api.venmo.com/v1/payments?access_token=\(atoken)&phone=\(phone)&amount=\(amount)&note=\(message)&audience=\(audience)"
                        var url = NSURL(string: url_str)
                        var request = NSMutableURLRequest(URL: url!)
                        request.HTTPMethod = "POST"
                        request.timeoutInterval = 4.0
                        
                        var msg =  NSURLConnection.sendSynchronousRequest(request, returningResponse: response, error:nil)
                
                        if (msg != nil) {
                            println(NSJSONSerialization.JSONObjectWithData(msg!, options: .MutableContainers, error: nil))
                        }
                    }
                    index = index + 1
                }
        }
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
}
