//
//  SettingsBar.swift
//  SplitPea
//
//  Created by Vinizzle on 1/8/15.
//  Copyright (c) 2015 OkraLabs. All rights reserved.
//

import UIKit

@objc protocol SettingsBarDelegate {
    func SettingsBarDidSelectButton(index: Int)
    func openCloseSettingsBar()
    optional func SettingsBarWillClose()
    optional func SettingsBarWillOpen()
}

class SettingsBar: NSObject, SettingsTableViewControllerDelegate {
    let barwidth:CGFloat = 200.0
    let SettingsBarTableViewTopInsert: CGFloat = 64.0
    let SettingsBarContainerView:UIView = UIView()
    let SettingsBarTableViewController:SettingsTableViewController = SettingsTableViewController()
    let originView:UIView!
    
    var animator:UIDynamicAnimator!
    var delegate:SettingsBarDelegate?
    var isSettingsBarOpen:Bool = false
    
    override init() {
        originView = UIView()
        super.init()
    }
    
    init(sourceView:UIView, menuItems: Array<String>) {
        originView = sourceView
        super.init()
        SettingsBarTableViewController.tableViewData = menuItems
        animator = UIDynamicAnimator(referenceView: originView)
        setupSettingsBar()

        let showClose:UIGestureRecognizer = UIGestureRecognizer(target: self, action: "openCloseSettingsBar")
        let hideGestureRecognizer:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target:self, action:"handleSwipe:")
        hideGestureRecognizer.direction = UISwipeGestureRecognizerDirection.Left
        originView.addGestureRecognizer(hideGestureRecognizer)
    }
    
    func setupSettingsBar() {
        SettingsBarContainerView.frame = CGRectMake(-barwidth-1, originView.frame.origin.y, barwidth, originView.frame.size.height)
        SettingsBarContainerView.backgroundColor = UIColor(red: 0.004, green: 0.596, blue: 0.459, alpha: 1.0)
        SettingsBarContainerView.clipsToBounds = false
        
        originView.addSubview(SettingsBarContainerView)
        
        SettingsBarTableViewController.delegate = self
        SettingsBarTableViewController.tableView.frame = SettingsBarContainerView.bounds
        SettingsBarTableViewController.tableView.clipsToBounds = false
        SettingsBarTableViewController.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        SettingsBarTableViewController.tableView.backgroundColor = UIColor(red: 0.004, green: 0.596, blue: 0.459, alpha: 1.0)
        SettingsBarTableViewController.tableView.scrollsToTop = false
        SettingsBarTableViewController.tableView.contentInset = UIEdgeInsetsMake(SettingsBarTableViewTopInsert, 0, 0, 0)
        SettingsBarTableViewController.tableView.reloadData()
        
        SettingsBarContainerView.addSubview(SettingsBarTableViewController.tableView)
    }
    
    func openCloseSettingsBar() {
        if isSettingsBarOpen == false {
            showSettingsBar(true)
            delegate?.SettingsBarWillOpen?()
            
        } else {
            showSettingsBar(false)
            delegate?.SettingsBarWillClose?()
        }
    }
    
    func handleSwipe(recognizer:UISwipeGestureRecognizer) {
        if recognizer.direction == UISwipeGestureRecognizerDirection.Left {
            showSettingsBar(false)
            delegate?.SettingsBarWillClose?()
        }
    }
    
    func showSettingsBar(shouldOpen: Bool) {
        isSettingsBarOpen = shouldOpen
        let gravityX:CGFloat = (shouldOpen) ? 0.5: -0.5
        let magnitudeX:CGFloat = (shouldOpen) ? 20: -20
        let boundaryX:CGFloat = (shouldOpen) ? barwidth: -barwidth-1
        
        let gravityBehavior: UIGravityBehavior = UIGravityBehavior(items: [SettingsBarContainerView])
        gravityBehavior.gravityDirection = CGVectorMake(gravityX, 0)
        animator.addBehavior(gravityBehavior)
        
        let collisionBehavior: UICollisionBehavior = UICollisionBehavior(items: [SettingsBarContainerView])
        collisionBehavior.addBoundaryWithIdentifier("SettingsBarBoundary", fromPoint: CGPointMake(boundaryX, 20), toPoint: CGPointMake(boundaryX, originView.frame.size.height))
        animator.addBehavior(collisionBehavior)
        
        let pushBehavior:UIPushBehavior = UIPushBehavior(items: [SettingsBarContainerView], mode: UIPushBehaviorMode.Instantaneous)
        pushBehavior.magnitude = magnitudeX
        animator.addBehavior(pushBehavior)
        
        let settingsBarBehavior:UIDynamicItemBehavior = UIDynamicItemBehavior(items: [SettingsBarContainerView])
        settingsBarBehavior.elasticity = 0.3
        animator.addBehavior(settingsBarBehavior)
    }
    
    func SettingsTableDidSelectRow(indexPath: NSIndexPath) {
        delegate?.SettingsBarDidSelectButton(indexPath.row)
    }
    
}
