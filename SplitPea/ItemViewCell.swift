//
//  ItemViewCell.swift
//  SplitPea
//
//  Created by Vinizzle on 2/11/15.
//  Copyright (c) 2015 OkraLabs. All rights reserved.
//

import UIKit

class ItemViewCell: UITableViewCell, UITextFieldDelegate {

    @IBOutlet weak var quantity: UITextField!
    @IBOutlet weak var item:  UILabel!
    @IBOutlet weak var item_amount: UITextField!
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if (textField == quantity) {
            self.quantity.endEditing(true)
            return false
        } else {
            self.item_amount.endEditing(true)
            return false
        }
    }
    
    @IBAction func quantityChanged(sender: AnyObject) {
        var row = super.indexOfAccessibilityElement(self)
        var tableView: UITableView = self.superview?.superview as! UITableView
        var indexPath:NSIndexPath = tableView.indexPathForCell(self)!

        var id = PFUser.currentUser().valueForKey("recentReceiptId") as! NSString
        var query = PFQuery(className:"receiptData")
        var data_object: PFObject = query.getObjectWithId(id as String) as PFObject
        var numItemsArray: NSMutableArray = data_object.valueForKey("numItemsArray") as! NSMutableArray
        numItemsArray[indexPath.row] = quantity.text
        data_object.setObject(numItemsArray, forKey: "numItemsArray")
        data_object.save()

    }
    
    @IBAction func costChanged(sender: AnyObject) {
        var row = super.indexOfAccessibilityElement(self)
        var tableView: UITableView = self.superview?.superview as! UITableView
        var indexPath:NSIndexPath = tableView.indexPathForCell(self)!
        
        var id = PFUser.currentUser().valueForKey("recentReceiptId") as! NSString
        var query = PFQuery(className:"receiptData")
        var data_object: PFObject = query.getObjectWithId(id as String) as PFObject
        var costArray: NSMutableArray = data_object.valueForKey("costArray") as! NSMutableArray
        costArray[indexPath.row] = item_amount.text
        data_object.setObject(costArray, forKey: "costArray")
        data_object.save()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        quantity.delegate = self
        item_amount.delegate = self
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}