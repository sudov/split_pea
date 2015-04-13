//
//  CurrentChecksViewCell.swift
//  SplitPea
//
//  Created by Vinizzle on 2/24/15.
//  Copyright (c) 2015 OkraLabs. All rights reserved.
//

import Foundation

class CurrentChecksViewCell: UITableViewCell {
    
    
    @IBOutlet weak var tabPreview: UIImageView!
    
    @IBOutlet weak var tabTitle: UILabel!

    @IBOutlet weak var isOwnerLabel: UILabel!
    
    @IBAction func visitSelectedTab(sender: AnyObject) {
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