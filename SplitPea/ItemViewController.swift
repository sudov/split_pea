//
//  ItemViewController.swift
//  SplitPea
//
//  Created by Vinizzle on 1/2/15.
//  Copyright (c) 2015 OkraLabs. All rights reserved.
//

import UIKit

class ItemViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate {
    
    var receive_jsonResult: NSDictionary = [:];
    var jsonResult: NSDictionary = [:];
    
    // Receipt Content Data Structures
    var itemArray: NSArray!
    var costArray: NSArray!
    var numItems: NSArray!
    
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
        println(jsonResult)
        itemArray       =   jsonResult["item"] as NSArray
        costArray       =   jsonResult["cost"] as NSArray
        numItems        =   jsonResult["num_item_array"] as NSArray
        subTotal.text   =   jsonResult["sub-total"] as NSString
        tax.text        =   jsonResult["tax"] as NSString
        finalTotal.text =   jsonResult["final_total"] as NSString
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
    
    @IBAction func Charged(sender: AnyObject) {
        let alert = UIAlertController(title: "", message: "You're friends have been charged!", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
}
