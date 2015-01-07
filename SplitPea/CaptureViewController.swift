//
//  CaptureViewController.swift
//  SplitPea
//
//  Created by Vinizzle on 1/3/15.
//  Copyright (c) 2015 OkraLabs. All rights reserved.
//

import UIKit

class CaptureViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var cameraUI:UIImagePickerController = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        let screenWidth = screenSize.width;
        let screenHeight = screenSize.height;
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
            println("Yay Camera!")
        } else {
            println("No Camera Available")
        }
    }
    
    @IBOutlet weak var SnappedReceipt: UIImageView!
    
    @IBAction func UploadReceipt(sender: AnyObject) {
        println("WUT")
        cameraUI = UIImagePickerController()
        cameraUI.delegate = self
        cameraUI.sourceType = UIImagePickerControllerSourceType.SavedPhotosAlbum  //because mac camera -.-
        //        cameraUI.sourceType = UIImagePickerControllerSourceType.Camera
        //        cameraUI.mediaTypes = [kUTTypeImage]
        cameraUI.allowsEditing = false
        self.presentViewController(cameraUI, animated: true, completion: nil)
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
        
        var url = NSURL(string: "http://getsplitpea.com:5000/") // can do php too but its annoying
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
            var jsonResult: NSDictionary = NSJSONSerialization.JSONObjectWithData(dataVal!, options: NSJSONReadingOptions.MutableContainers, error: nil) as NSDictionary
            println("Synchronous\(jsonResult)")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
