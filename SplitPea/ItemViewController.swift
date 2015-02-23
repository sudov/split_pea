//
//  ItemViewController.swift
//  SplitPea
//
//  Created by Vinizzle on 1/2/15.
//  Copyright (c) 2015 OkraLabs. All rights reserved.
//

import UIKit
import CoreData

class ItemViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UICollectionViewDelegate, UITextFieldDelegate, UICollectionViewDelegateFlowLayout {
    
    var receive_jsonResult: NSDictionary = [:];
    var jsonResult: NSDictionary = [:];
    
    // Receipt Content Data Structures
    var itemArray: NSArray!
    var costArray: NSArray!
    var numItems: NSArray!
    var subTotalCoreData: NSString!
    var taxCoreData: NSString!
    var finalTotalCoreData: NSString!
    
    var searches = [UIImage]()
    
    @IBOutlet weak var friendsInTab: UICollectionView!
    @IBOutlet weak var subTotal: UILabel!
    @IBOutlet weak var tax: UILabel!
    @IBOutlet weak var finalTotal: UILabel!
    
    @IBOutlet weak var tableView: UITableView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.dataSource = self
        tableView.delegate = self
        jsonResult = receive_jsonResult;
//        println(jsonResult)
        
//        Grab stuff from Segue
        itemArray       =   jsonResult["item"] as NSArray
        costArray       =   jsonResult["cost"] as NSArray
        numItems        =   jsonResult["num_item_array"] as NSArray
        subTotalCoreData    =   jsonResult["sub-total"] as NSString
        taxCoreData     =   jsonResult["tax"] as NSString
        finalTotalCoreData  = jsonResult["final_total"] as NSString

        subTotal.text   =   subTotalCoreData
        tax.text        =   taxCoreData
        finalTotal.text =   finalTotalCoreData
        
        searches += [UIImage(named: "pic1.jpg")!, UIImage(named: "pic2.jpg")!]
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) ->Int
    {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
//        return self.items.count;
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
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        println("You selected cell #\(indexPath.row)!")
    }
    
    func numberOfComponentsInPickerView(picker: UIPickerView!)-> Int {
        return 1
    }

    func pickerView(picker: UIPickerView!, numberOfRowsInComponent component: Int)-> Int {
        return 30
    }
    
    func pickerView(picker: UIPickerView!, titleForRow row: Int,numberOfRowsInComponent component: Int)-> String! {
        if (row < numItems.count) {
            return numItems[row] as NSString
        } else {
            return String(row)
        }
        
    }
    
    
    // Collection View Stuff
    //1
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return searches.count
    }
    
    //2
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searches.count
    }
    
    //3
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        //1
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CCell", forIndexPath: indexPath) as FriendsCellCollectionViewController
        
        cell.friendPicture.image = searches[0]
        
        return cell
    }
    // MARK: UICollectionViewDelegateFlowLayout
    
    //1
    func collectionView(collectionView: UICollectionView!,
        layout collectionViewLayout: UICollectionViewLayout!,
        sizeForItemAtIndexPath indexPath: NSIndexPath!) -> CGSize {
            return CGSize(width: 100, height: 100)
    }
    
    //3
    private let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)
    
    func collectionView(collectionView: UICollectionView!,
        layout collectionViewLayout: UICollectionViewLayout!,
        insetForSectionAtIndex section: Int) -> UIEdgeInsets {
            return sectionInsets
    }
    
    @IBAction func Charged(sender: AnyObject) {
        let alert = UIAlertController(title: "", message: "You're friends have been charged!", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    @IBAction func addFriendToTab(sender: AnyObject) {
    }
    
    
}
