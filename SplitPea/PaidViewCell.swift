//
//  PaidViewCell.swift
//  SplitPea
//
//  Created by Vinizzle on 4/25/15.
//  Copyright (c) 2015 OkraLabs. All rights reserved.
//

import UIKit

class PaidViewCell: UITableViewCell {

    @IBOutlet weak var paidPic: FBProfilePictureView!
    @IBOutlet weak var paidName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
