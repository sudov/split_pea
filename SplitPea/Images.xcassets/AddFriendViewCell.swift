//
//  AddFriendViewCell.swift
//  SplitPea
//
//  Created by Vinizzle on 4/2/15.
//  Copyright (c) 2015 OkraLabs. All rights reserved.
//

import UIKit

class AddFriendViewCell: UITableViewCell {


    @IBOutlet weak var friendPic: FBProfilePictureView!
    @IBOutlet weak var friendName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
