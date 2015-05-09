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
        SnappedReceipt.clipsToBounds = true
        
        var alertview = JSSAlertView().show(
            self, // the parent view controller of the alert
            title: "Heads up!", // the alert's title
            text: "Avoid shadows while snapping your picture.",
            color: UIColor(red: (67.0/255.0), green: (180.0/255.0), blue: (112.0/255.0), alpha: 0.5),
            iconImage: UIImage(named: "lightbulb.png")
        )
        alertview.setTitleFont("ClearSans-Bold")
        alertview.setTextFont("ClearSans")
        alertview.setButtonFont("ClearSans-Light")
        alertview.setTextTheme(.Light)
    }
    
    @IBOutlet weak var SnappedReceipt: UIImageView!
    var load_img: UIImage? = UIImage()
    
    func openCamera()
    {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera))
        {
            cameraUI = UIImagePickerController()
            cameraUI.delegate = self
            cameraUI.allowsEditing = true
            cameraUI.sourceType = UIImagePickerControllerSourceType.Camera
            self.presentViewController(cameraUI, animated: true, completion: nil)
        }
    }
    
    func openGallary()
    {
        cameraUI.delegate = self
        cameraUI.allowsEditing = true
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
        SnappedReceipt.image  = image
        loading()
        self.dismissViewControllerAnimated(true, completion: { () -> Void in
            self.sendServerRequest(image)
        })
    }
    
    

    func loading() {
        // angles in iOS are measured as radians PI is 180 degrees so PI × 2 is 360 degrees
        let fullRotation = CGFloat(M_PI * 2)
        let duration = 7.0
        let delay = 0.0
        
        self.parentViewController?.view.bounds
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        let screenWidth = screenSize.width;
        let screenHeight = screenSize.height;
        let options = UIViewKeyframeAnimationOptions.CalculationModePaced
        
        let fish = UIImageView()
        fish.image = UIImage(named: "peas.png")
        fish.frame = CGRect(x: screenWidth*0.42, y: screenHeight*0.42, width: 40, height: 80)
        fish.clipsToBounds = true
        self.view.addSubview(fish)
        self.view.bringSubviewToFront(fish)

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
        
        var url = NSURL(string: "http://45.55.248.107:5000/")
        var data = NSData(data:UIImageJPEGRepresentation(image, 1.0))
        var request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "POST"
        request.HTTPBody = NSData(data:UIImageJPEGRepresentation(image, 1.0))
        request.setValue("image/jpeg", forHTTPHeaderField: "Content-Type")
        request.setValue("form-data; name=userfile; filename=receipt.jpg", forHTTPHeaderField: "Content-Disposition")
        request.timeoutInterval = 4.0
        
        var dataVal =  NSURLConnection.sendSynchronousRequest(request, returningResponse: response, error:nil)
        
//        var alert = UIAlertView()
        
        if (dataVal == nil) {
            var alertview = JSSAlertView().show(
                self, // the parent view controller of the alert
                title: "Oops!", // the alert's title
                text: "Our server currently has a lot of traffic. Re-upload?",
                color: UIColor(red: (244.0/255.0), green: (63.0/255.0), blue: (79.0/255.0), alpha: 0.5),
                iconImage: UIImage(named: "error.png")
            )
            alertview.setTitleFont("ClearSans-Bold")
            alertview.setTextFont("ClearSans")
            alertview.setButtonFont("ClearSans-Light")
            alertview.setTextTheme(.Light)

//            alert.title = "Ooops!"
//            alert.message = "Our server currently has a lot of traffic. Re-upload?"
//            alert.addButtonWithTitle("OK")
//            alert.show()
        } else {
            jsonResult = NSJSONSerialization.JSONObjectWithData(dataVal!, options: NSJSONReadingOptions.MutableContainers, error: nil) as! NSDictionary
            var userObjID = PFUser.currentUser().objectId
            
//            Creating entry in Parse's receipt class
            var newReceipt = PFObject(className: "receiptData")
            newReceipt.setObject(user.objectId, forKey: "user_obj_id")
            newReceipt.setObject(jsonResult, forKey: "data")
            newReceipt.setObject([FBProfilePictureView](), forKey: "friendsOnReceipt")
            newReceipt.setObject(true, forKey: "first")
            newReceipt.saveInBackgroundWithBlock({
                (success: Bool, error: NSError!) -> Void in
                if (success){
                    NSLog("Object created with id: \(newReceipt.objectId)")
                    PFUser.currentUser().setObject("\(newReceipt.objectId)", forKey: "recentReceiptId")
                    PFUser.currentUser().saveInBackgroundWithBlock({
                        (success: Bool, error: NSError!) -> Void in
                        if (success) {
                            self.performSegueWithIdentifier("goToItemsAuto", sender: self)
                        } else {
                            NSLog("Error Updating User", error!)
                            var alertview = JSSAlertView().show(
                                self, // the parent view controller of the alert
                                title: "Oops!", // the alert's title
                                text: "Your session just expired. Could you log in again?",
                                color: UIColor(red: (244.0/255.0), green: (63.0/255.0), blue: (79.0/255.0), alpha: 0.5),
                                iconImage: UIImage(named: "error.png")
                            )
                            alertview.setTitleFont("ClearSans-Bold")
                            alertview.setTextFont("ClearSans")
                            alertview.setButtonFont("ClearSans-Light")
                            alertview.setTextTheme(.Light)
                            
//                            alert.title = "Oops!"
//                            alert.message = "Your session just expired. Could you log in again?"
//                            alert.addButtonWithTitle("OK")
//                            alert.show()
                        }
                    })
                    //            Saving receipt image to Parse
                    var file: PFFile = PFFile(data: UIImageJPEGRepresentation(image, 0.7))
                    file.saveInBackgroundWithBlock({ (success, fileError) -> Void in
                        if success {
                            newReceipt["receiptImg"] = file
                            newReceipt.saveInBackgroundWithBlock({ (success, objError) -> Void in
                                if success {
                                    NSLog("Photo object saved")
                                } else {
                                    NSLog("Unable to create a photo object: \(objError)", error!)
                                }
                            })
                        } else {
                            NSLog("Unable to save file: \(fileError)", error!)
                        }
                    })
                    
                } else {
                    NSLog("Error in saving new receipt!", error!)
                    var alertview = JSSAlertView().show(
                        self, // the parent view controller of the alert
                        title: "Oops!", // the alert's title
                        text: "Our server has a snag. Return to the previous screen and retry!",
                        color: UIColor(red: (244.0/255.0), green: (63.0/255.0), blue: (79.0/255.0), alpha: 0.5),
                        iconImage: UIImage(named: "error.png")
                    )
                    alertview.setTitleFont("ClearSans-Bold")
                    alertview.setTextFont("ClearSans")
                    alertview.setButtonFont("ClearSans-Light")
                    alertview.setTextTheme(.Light)
                    
//                    alert.title = "Oops!"
//                    alert.message = "Our server has a snag. Return to the previous screen and retry!"
//                    alert.addButtonWithTitle("OK")
//                    alert.show()
                }
            })
        }
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
