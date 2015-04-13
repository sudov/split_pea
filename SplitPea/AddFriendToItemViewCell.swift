//
//  AddFriendToItemViewCell.swift
//  SplitPea
//
//  Created by Vinizzle on 4/9/15.
//  Copyright (c) 2015 OkraLabs. All rights reserved.
//

import UIKit

class AddFriendToItemViewCell: UITableViewCell {


    @IBOutlet weak var itemFriendPic: FBProfilePictureView!
    
    @IBOutlet weak var itemFriendName: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
