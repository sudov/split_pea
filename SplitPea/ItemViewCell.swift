
//
//  ItemViewCell.swift
//  SplitPea
//
//  Created by Vinizzle on 2/11/15.
//  Copyright (c) 2015 OkraLabs. All rights reserved.
//

import UIKit

class ItemViewCell: UITableViewCell {

    
    
    @IBOutlet weak var quantity: UITextField!
    @IBOutlet weak var item:  UILabel!
    @IBOutlet weak var user_img: UIImageView!
    @IBOutlet weak var item_amount: UITextField!
    
    func numberOfComponentsInPickerView(picker: UIPickerView!)-> Int {
        return 1
    }
    
    func pickerView(picker: UIPickerView!, numberOfRowsInComponent component: Int)-> Int {
        return 30
    }
    
    func pickerView(picker: UIPickerView!, titleForRow row: Int,numberOfRowsInComponent component: Int)-> String! {
        return ""
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
