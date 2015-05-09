//
//  AddFriendsToTabViewController.swift
//  SplitPea
//
//  Created by Vinizzle on 4/2/15.
//  Copyright (c) 2015 OkraLabs. All rights reserved.
//

import UIKit

class AddFriendsToTabViewController: UIViewController, UITableViewDataSource, UITableViewDelegate,UISearchBarDelegate {
    
    var searches = [UIImage]()
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var addFriendsTableView: UITableView!
    
    var searchActive : Bool = true
    
//    var ownerProfPic: String!
    var names    = [String]()
    var pictures = [String]()
    var filtered = [String]()
    var filteredImages = [String]()
    var picture_correlation = [String:String]()
    
    var friendsAdded = [String]()
    var friendsAddedNames = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.sharedApplication().statusBarStyle = .LightContent

        var profPic = (PFUser.currentUser().valueForKey("picture") as! NSString) as String
        pictures.append(profPic)
        var userName: String = PFUser.currentUser().valueForKey("displayName") as! String
        names.append("\(userName)")
        picture_correlation[userName as String] = profPic as String
        
        if (FBSession.activeSession().self.isOpen == false){
            FBSession.openActiveSessionWithAllowLoginUI(true)
        }
        
        FBRequestConnection.startForMyFriendsWithCompletionHandler({ (connection:FBRequestConnection!, result, error: NSError!) -> Void in
            if error == nil {
                var friendObjects = result["data"] as! [NSDictionary]
                for friendObject in friendObjects {
                    self.names.append(friendObject["name"] as! String)
                    self.pictures.append(friendObject["id"] as! String)
                    var temp_name = friendObject["name"] as! String
                    var temp_pic  = friendObject["id"] as! String
                    self.picture_correlation[temp_name] = temp_pic
                }
            }
        })

        addFriendsTableView.delegate = self
        addFriendsTableView.dataSource = self
        searchBar.delegate = self
        self.addFriendsTableView.reloadData()
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchActive = true;
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
        filtered = names.filter({ (text) -> Bool in
            let tmp: NSString = text
            let range = tmp.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch)
            return range.location != NSNotFound
        })
        
        var filteredCorr = names.filter({ (text) -> Bool in
            let tmp: NSString = text
            let range = tmp.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch)
            return range.location != NSNotFound
        })
        
        for photo in filteredCorr {
            filteredImages.append(picture_correlation["\(photo)"]!)
        }

        if(filtered.count == 0){
            searchActive = false;
        } else {
            searchActive = true;
        }
        self.addFriendsTableView.reloadData()
    }
    
//    TableView Stuff
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(searchActive) {
            return filtered.count
        } else {
            return names.count;
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell : AddFriendViewCell! = tableView.dequeueReusableCellWithIdentifier("findFriendCell") as! AddFriendViewCell
        if(searchActive){
            cell.friendName?.text = filtered[indexPath.row]
            cell.friendPic?.profileID = filteredImages[indexPath.row]
            cell.accessoryType = .None
        } else {
            cell.friendPic?.profileID = pictures[indexPath.row]
            cell.friendName?.text = names[indexPath.row]
            cell.accessoryType = .None
        }
        var width: CGFloat! = cell.friendPic?.frame.size.width
        cell.friendPic?.layer.cornerRadius = (width / 2)
        cell.friendPic?.clipsToBounds = true
        
        return cell;
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if (searchActive) {
            let cell: AddFriendViewCell! = tableView.cellForRowAtIndexPath(indexPath) as! AddFriendViewCell
            if (cell?.accessoryType == UITableViewCellAccessoryType.Checkmark) {
                cell?.accessoryType = .None
                for index in 0...friendsAdded.count {
                    if friendsAdded[index] == cell?.friendPic.profileID {
                        friendsAdded.removeAtIndex(index)
                        friendsAddedNames.removeAtIndex(index)
                        break
                    }
                }
            } else {
                cell?.accessoryType = .Checkmark
                if contains(friendsAdded, "\(cell?.friendPic.profileID)") == false {
                    var str_pic = cell.friendPic.profileID
                    friendsAdded.append(str_pic)
                    var str_name = cell.friendName.text
                    friendsAddedNames.append(str_name!)
                }
            }
        } else {
            let cell: AddFriendViewCell! = tableView.cellForRowAtIndexPath(indexPath) as! AddFriendViewCell
            if (cell?.accessoryType == UITableViewCellAccessoryType.Checkmark) {
                cell?.accessoryType = .None
                for index in 0...friendsAdded.count {
                    if friendsAdded[index] == cell?.friendPic.profileID {
                        friendsAdded.removeAtIndex(index)
                        friendsAddedNames.removeAtIndex(index)
                        break
                    }
                }
            } else {
                cell?.accessoryType = .Checkmark
                if contains(friendsAdded, "\(cell?.friendPic.profileID)") == false {
                    var str_pic = cell.friendPic.profileID
                    friendsAdded.append(str_pic)
                    var str_name = cell.friendName.text
                    friendsAddedNames.append(str_name!)
                }
            }
        }
    }
    
    func tableView(tableView: UITableView, sectionForSectionIndexTitle title: String, atIndex index: Int) -> Int {
        if (searchActive) {
            return filtered.count
        } else {
            return names.count
        }
    }
    
    @IBAction func doneAddingFriends(sender: AnyObject) {
        //        Grab receipt JSON from Parse
        var id = PFUser.currentUser().valueForKey("recentReceiptId") as! NSString
        var query = PFQuery(className:"receiptData")
        var tabParticipants: PFObject! = query.getObjectWithId(id as String) as PFObject

        tabParticipants.setObject(friendsAdded, forKey: "friendsOnReceipt")
        tabParticipants.setObject(friendsAddedNames, forKey: "friendsOnReceiptNames")
        tabParticipants.saveInBackgroundWithBlock ({
            (success: Bool, error: NSError?) -> Void in
            if (success) {
                self.performSegueWithIdentifier("goBackToItemView", sender: self)
            } else {
                NSLog("FAILURE!! Couldn't add friends to Tab", error!)
            }
        })
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
