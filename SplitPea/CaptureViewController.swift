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
        println("asfdfas")
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        let screenWidth = screenSize.width;
        let screenHeight = screenSize.height;
        user = PFUser.currentUser()
        println("CaptureViewController: " + user.username)
    }
    
    @IBOutlet weak var SnappedReceipt: UIImageView!
    
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
        var alert:UIAlertController=UIAlertController(title: "Choose Image", message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        
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
    
    func imagePickerController(cameraUI: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo:NSDictionary!) {
        SnappedReceipt.bounds = UIScreen.mainScreen().bounds
        SnappedReceipt.image  = image
        sendServerRequest(image)
        
        self.dismissViewControllerAnimated(true, completion: { () -> Void in })
    }
    
    func sendServerRequest(image: UIImage){
        var response: AutoreleasingUnsafeMutablePointer<NSURLResponse?>=nil
        var error: AutoreleasingUnsafeMutablePointer<NSError?> = nil
        
        var url = NSURL(string: "http://getsplitpea.com:5000/") 
        var data = NSData(data:UIImageJPEGRepresentation(image, 1.0))
        var request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "POST"
        request.HTTPBody = NSData(data:UIImageJPEGRepresentation(image, 1.0))
        request.setValue("image/jpeg", forHTTPHeaderField: "Content-Type")
        request.setValue("form-data; name=userfile; filename=receipt.jpg", forHTTPHeaderField: "Content-Disposition")
        request.timeoutInterval = 4.0
        println(request.allHTTPHeaderFields)
        
        var dataVal =  NSURLConnection.sendSynchronousRequest(request, returningResponse: response, error:nil)
        
        if ( dataVal == nil ) {
            println("Nothing came back :(")
        } else {
            jsonResult = NSJSONSerialization.JSONObjectWithData(dataVal!, options: NSJSONReadingOptions.MutableContainers, error: nil) as NSDictionary
            var userObjID = PFUser.currentUser().objectId

//            Creating entry in Parse's receipt class
            var newReceipt = PFObject(className: "receiptData")
            newReceipt.setObject(user.objectId, forKey: "user_obj_id")
            newReceipt.setObject(jsonResult, forKey: "data")
            newReceipt.setObject([FBProfilePictureView](), forKey: "friendsOnReceipt")
            newReceipt.saveInBackgroundWithBlock {
                (success: Bool!, error: NSError!) -> Void in
                if (success != nil) {
                    NSLog("Object created with id: \(newReceipt.objectId)")
                    PFUser.currentUser().setObject("\(newReceipt.objectId)", forKey: "recentReceiptId")
                    PFUser.currentUser().save()
                } else {
                    NSLog("%@", error)
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
