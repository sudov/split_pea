//
//  PaidViewController.swift
//  SplitPea
//
//  Created by Vinizzle on 1/6/15.
//  Copyright (c) 2015 OkraLabs. All rights reserved.
//

import UIKit

class PaidViewController: UIViewController {
    
    var circle = ProgressCircle(frame: CGRectMake(82, 291, 210, 235))
    
    @IBOutlet weak var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.sharedApplication().statusBarStyle = .LightContent

        circle.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(circle)
        label.center = CGPointMake(160, 284)
        label.textAlignment = NSTextAlignment.Center
        label.text = String(Int(Float(circle.getProgress()*100)))
        self.view.addSubview(label)

    }
    
    @IBAction func refresh(sender: AnyObject) {
        circle.incProgress()
        label.text = String(Int(Float(circle.getProgress()*100)))
        circle.setNeedsDisplay()
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
