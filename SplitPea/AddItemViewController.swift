//
//  AddItemViewController.swift
//  SplitPea
//
//  Created by Vinizzle on 5/9/15.
//  Copyright (c) 2015 OkraLabs. All rights reserved.
//

import UIKit

class AddItemViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var item_name: UITextField!
    @IBOutlet weak var item_quantity: UITextField!
    @IBOutlet weak var item_cost: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        
        self.item_name.delegate = self
        self.item_quantity.delegate = self
        self.item_cost.delegate = self
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    @IBAction func doneAdding(sender: AnyObject) {
        if (item_name.text != nil && item_quantity.text != nil && item_cost.text != nil) {
            var id = PFUser.currentUser().valueForKey("recentReceiptId") as! NSString
            var query = PFQuery(className:"receiptData")
            var data_object: PFObject = query.getObjectWithId(id as String) as PFObject
            var cost_array: NSMutableArray = data_object.valueForKey("costArray") as! NSMutableArray
            var item_array: NSMutableArray = data_object.valueForKey("itemArray") as! NSMutableArray
            var num_items_array: NSMutableArray = data_object.valueForKey("numItemsArray") as! NSMutableArray
            
            cost_array.addObject("\(item_cost.text)")
            item_array.addObject("\(item_name.text)")
            num_items_array.addObject("\(item_quantity.text)")
            if let count = data_object.valueForKey("itemCount") as? Int {
                data_object.setObject(count+1, forKey: "itemCount")
            }
            data_object.setObject(cost_array, forKey: "costArray")
            data_object.setObject(item_array, forKey: "itemArray")
            data_object.setObject(num_items_array, forKey: "numItemsArray")
            data_object.saveInBackgroundWithBlock({
                (success: Bool, error: NSError!) -> Void in
                if (success) {
                    self.performSegueWithIdentifier("doneAdding", sender: self)
                }
            })
            
        } else {
            var alertview = JSSAlertView().show(
                self, // the parent view controller of the alert
                title: "All three entries are required!",
                color: UIColor(red: (244.0/255.0), green: (63.0/255.0), blue: (79.0/255.0), alpha: 0.5),
                iconImage: UIImage(named: "error.png")
            )
            alertview.setTitleFont("ClearSans-Bold")
            alertview.setTextFont("ClearSans")
            alertview.setButtonFont("ClearSans-Light")
            alertview.setTextTheme(.Light)
        }
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
