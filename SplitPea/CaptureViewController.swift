//
//  CaptureViewController.swift
//  SplitPea
//
//  Created by Vinizzle on 1/3/15.
//  Copyright (c) 2015 OkraLabs. All rights reserved.
//

import UIKit

class CaptureViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var captureButton: UIButton!
    var popover:UIPopoverController?=nil
    
    var cameraUI:UIImagePickerController = UIImagePickerController()
    var jsonResult: NSDictionary!;
    var user: PFUser = PFUser()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        
        user = PFUser.currentUser()
    }
    
    @IBOutlet weak var SnappedReceipt: UIImageView!
    var load_img: UIImage? = UIImage()
    
    func openCamera()
    {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera))
        {
            cameraUI = UIImagePickerController()
            cameraUI.delegate = self
            cameraUI.sourceType = UIImagePickerControllerSourceType.Camera
            cameraUI.allowsEditing = false
            self.presentViewController(cameraUI, animated: true, completion: nil)
        }
    }
    
    func openGallary()
    {
        cameraUI.delegate = self
        cameraUI.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone
        {
            self.presentViewController(cameraUI, animated: true, completion: nil)
        }
        else
        {
            popover=UIPopoverController(contentViewController: cameraUI)
            popover!.presentPopoverFromRect(captureButton.frame, inView: self.view, permittedArrowDirections: UIPopoverArrowDirection.Any, animated: true)
        }
    }
    
    @IBAction func UploadReceipt(sender: AnyObject) {
        var alert:UIAlertController=UIAlertController(title: "Choose Image Source", message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        var cameraAction = UIAlertAction(title: "Camera", style: UIAlertActionStyle.Default)
            {
                UIAlertAction in
                self.openCamera()
                
        }
        var gallaryAction = UIAlertAction(title: "Gallery", style: UIAlertActionStyle.Default)
            {
                UIAlertAction in
                self.openGallary()
        }
        var cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel)
            {
                UIAlertAction in
                
        }
        // Add the actions
        alert.addAction(cameraAction)
        alert.addAction(gallaryAction)
        alert.addAction(cancelAction)
        // Present the actionsheet
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone
        {
            self.presentViewController(alert, animated: true, completion: nil)
        }
        else
        {
            popover=UIPopoverController(contentViewController: alert)
            popover!.presentPopoverFromRect(captureButton.frame, inView: self.view, permittedArrowDirections: UIPopoverArrowDirection.Any, animated: true)
        }
    }
    
    func imagePickerController(cameraUI: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        println("in picker controller")
        SnappedReceipt.bounds = UIScreen.mainScreen().bounds
        SnappedReceipt.image  = image
//        sendServerRequest(image)
        loading()
        self.dismissViewControllerAnimated(true, completion: { () -> Void in
            self.sendServerRequest(image)
        })
    }
    
    

    func loading() {
        // angles in iOS are measured as radians PI is 180 degrees so PI × 2 is 360 degrees
        let fullRotation = CGFloat(M_PI * 2)
        let duration = 10.0
        let delay = 1.0
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        let screenWidth = screenSize.width;
        let screenHeight = screenSize.height;
        let options = UIViewKeyframeAnimationOptions.CalculationModePaced
        
        let fish = UIImageView()
        fish.image = UIImage(named: "loading.gif")
        fish.frame = CGRect(x: (screenWidth/2), y: (screenHeight/2), width: 70, height: 70)
        self.view.bringSubviewToFront(fish)
        self.view.addSubview(fish)
        
        UIView.animateKeyframesWithDuration(duration, delay: delay, options: options, animations: {
            
            // note that we've set relativeStartTime and relativeDuration to zero.
            // Because we're using `CalculationModePaced` these values are ignored
            // and iOS figures out values that are needed to create a smooth constant transition
            UIView.addKeyframeWithRelativeStartTime(0, relativeDuration: 0, animations: {
                fish.transform = CGAffineTransformMakeRotation(1/3 * fullRotation)
            })
            
            UIView.addKeyframeWithRelativeStartTime(0, relativeDuration: 0, animations: {
                fish.transform = CGAffineTransformMakeRotation(2/3 * fullRotation)
            })
            
            UIView.addKeyframeWithRelativeStartTime(0, relativeDuration: 0, animations: {
                fish.transform = CGAffineTransformMakeRotation(3/3 * fullRotation)
            })
            
            }, completion: nil)
    }
    
    func sendServerRequest(image: UIImage){
        var response: AutoreleasingUnsafeMutablePointer<NSURLResponse?>=nil
        var error: AutoreleasingUnsafeMutablePointer<NSError?> = nil
        
        var url = NSURL(string: "http://getsplitpea.com:5000/")
//        var url = NSURL(string: "http://45.55.248.107:5000/")
        var data = NSData(data:UIImageJPEGRepresentation(image, 1.0))
        var request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "POST"
        request.HTTPBody = NSData(data:UIImageJPEGRepresentation(image, 1.0))
        request.setValue("image/jpeg", forHTTPHeaderField: "Content-Type")
        request.setValue("form-data; name=userfile; filename=receipt.jpg", forHTTPHeaderField: "Content-Disposition")
        request.timeoutInterval = 4.0
        
        var dataVal =  NSURLConnection.sendSynchronousRequest(request, returningResponse: response, error:nil)
        
        var alert = UIAlertView()
        
        if (dataVal == nil) {
            println("Nothing came back :(")
            alert.title = "Ooops!"
            alert.message = "Something went wrong. Re-upload?"
            alert.addButtonWithTitle("Ok")
            alert.show()
        } else {
            jsonResult = NSJSONSerialization.JSONObjectWithData(dataVal!, options: NSJSONReadingOptions.MutableContainers, error: nil) as! NSDictionary
            var userObjID = PFUser.currentUser().objectId

//            Creating entry in Parse's receipt class
            var newReceipt = PFObject(className: "receiptData")
            newReceipt.setObject(user.objectId, forKey: "user_obj_id")
            newReceipt.setObject(jsonResult, forKey: "data")
            newReceipt.setObject([FBProfilePictureView](), forKey: "friendsOnReceipt")
            newReceipt.saveInBackgroundWithBlock ({
                (success: Bool, error: NSError?) -> Void in
                if (success) {
                    PFUser.currentUser().setObject("\(newReceipt.objectId)", forKey: "recentReceiptId")
                    PFUser.currentUser().save()
                    alert.title = "Woot!"
                    alert.message = "Hit Done!"
                    alert.addButtonWithTitle("Ok")
                    alert.show()
                } else {
                    NSLog("%@", error!)
                }
            })
        }
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
