//
//  BuyChosenCategoryViewController.swift
//  UPMarketplace
//
//  Created by Krismy on 11/30/14.
//  Copyright (c) 2014 UP Marketplace. All rights reserved.
//

import UIKit

class BuyChosenCategoryViewController: NewListingsViewController{
    
    var category: String?
   
    override func queryListings() {
        var query = PFQuery(className: "Listing")
        query.orderByDescending("createdAt")
        query.findObjectsInBackgroundWithBlock { (objects: [AnyObject]!, error: NSError!) -> Void in
            if let foundObjects = objects as? [PFObject] {
                
                self.listings.removeAll(keepCapacity: false)
                self.listings += foundObjects
                self.collectionView?.reloadData()
            }
        }

    }
}
