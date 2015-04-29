//
//  PaidViewController.swift
//  SplitPea
//
//  Created by Vinizzle on 1/6/15.
//  Copyright (c) 2015 OkraLabs. All rights reserved.
//

import UIKit

class PaidViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
//    var circle = ProgressCircle(frame: CGRectMake(82, 291, 210, 235))
    var tab_pics = [String]()
    var tab_names = [String]()
    @IBOutlet weak var paid_table: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        
        var id = PFUser.currentUser().valueForKey("recentReceiptId") as! NSString
        var query = PFQuery(className:"receiptData")
        var tabParticipants: PFObject! = query.getObjectWithId(id as String) as PFObject
        tab_pics = tabParticipants.valueForKey("friendsOnReceipt") as! [String]
        tab_names = tabParticipants.valueForKey("friendsOnReceiptNames") as! [String]
        
        paid_table.delegate = self
        paid_table.dataSource = self
        paid_table.reloadData()
        
//        circle.backgroundColor = UIColor.whiteColor()
//        self.view.addSubview(circle)
//        label.center = CGPointMake(160, 284)
//        label.textAlignment = NSTextAlignment.Center
//        label.text = String(Int(Float(circle.getProgress()*100)))
//        self.view.addSubview(label)

    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tab_pics.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell : PaidViewCell! = tableView.dequeueReusableCellWithIdentifier("paidViewCell") as! PaidViewCell
        cell.paidName.text = tab_names[indexPath.row]
        cell.paidPic.profileID = tab_pics[indexPath.row]
        var width: CGFloat! = cell.paidPic.frame.size.width
        cell.paidPic.layer.cornerRadius = (width / 2)
        cell.paidPic.clipsToBounds = true
        cell.accessoryType = .None
        
        return cell;
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell: PaidViewCell! = tableView.cellForRowAtIndexPath(indexPath) as! PaidViewCell
        
        if (cell?.accessoryType == UITableViewCellAccessoryType.Checkmark) {
            cell?.accessoryType = .None
            
//            Update the database
            var id = PFUser.currentUser().valueForKey("recentReceiptId") as! NSString
            var query = PFQuery(className:"receiptData")
            var tabParticipants: PFObject! = query.getObjectWithId(id as String) as PFObject
            var statusArr = [Bool]()
            statusArr = tabParticipants.valueForKey("statusArray") as! [Bool]
            statusArr[indexPath.row] = false
            tabParticipants.setObject(statusArr, forKey: "statusArray")
            tabParticipants.save()
        } else {
            cell?.accessoryType = .Checkmark
            
//            Update the database
            var id = PFUser.currentUser().valueForKey("recentReceiptId") as! NSString
            var query = PFQuery(className:"receiptData")
            var tabParticipants: PFObject! = query.getObjectWithId(id as String) as PFObject
            var statusArr = [Bool]()
            statusArr = tabParticipants.valueForKey("statusArray") as! [Bool]
            statusArr[indexPath.row] = true
            tabParticipants.setObject(statusArr, forKey: "statusArray")
            tabParticipants.save()
        }
    }
    
    
    @IBAction func refresh(sender: AnyObject) {
//        circle.incProgress()
//        label.text = String(Int(Float(circle.getProgress()*100)))
//        circle.setNeedsDisplay()
    }
    
    @IBAction func BackToCheckList(sender: AnyObject) {
        
    }
    
    
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
}

class ProgressCircle: UIView {
    var progress: CGFloat = 0.1
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func incProgress()-> Void {
        progress = progress + 0.1
    }
    
    func getProgress()-> CGFloat {
        return progress
    }
    
    override func drawRect(rect: CGRect) {
        var ctx = UIGraphicsGetCurrentContext()
        
//        var progress: CGFloat = 0.9
        var innerRadiusRatio: CGFloat = 0.5
        
        var path: CGMutablePathRef = CGPathCreateMutable()
        var startAngle: CGFloat = CGFloat(-M_PI_2)
        var endAngle: CGFloat = CGFloat(-M_PI_2) + min(1.0, progress) * CGFloat(M_PI * 2)
        var outerRadius: CGFloat = CGRectGetWidth(self.bounds) * 0.5 - 1.0
        var innerRadius: CGFloat = outerRadius * innerRadiusRatio
        var center = CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect))
        
        CGPathAddArc(path, nil, center.x, center.y, innerRadius, startAngle, endAngle, false)
        CGPathAddArc(path, nil, center.x, center.y, outerRadius, endAngle, startAngle, true)
        CGPathCloseSubpath(path)
        CGContextAddPath(ctx, path)
        
        //Draw the image, clipped to the path:
        CGContextSaveGState(ctx)
        CGContextClip(ctx)
        CGContextDrawImage(ctx, self.bounds, UIImage (named:"emerald")?.CGImage)
        CGContextRestoreGState(ctx)
        
        NSLog("drawRect has updated the view")
    }
}
