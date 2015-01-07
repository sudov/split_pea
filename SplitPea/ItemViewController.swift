//
//  ItemViewController.swift
//  SplitPea
//
//  Created by Vinizzle on 1/2/15.
//  Copyright (c) 2015 OkraLabs. All rights reserved.
//

import UIKit

class ItemViewController: UIViewController {

    @IBAction func Charged(sender: AnyObject) {
        let alert = UIAlertController(title: "", message: "You're friends have been charged!", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
}
