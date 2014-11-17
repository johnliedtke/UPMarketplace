//
//  NewListingsViewController.swift
//  UPMarketplace
//
//  Created by Krismy on 11/15/14.
//  Copyright (c) 2014 UP Marketplace. All rights reserved.
//


import UIKit


let reuseIdentifier = "listingViewCell"

class NewListingsViewController:UICollectionViewController, UICollectionViewDelegateFlowLayout {

  
    var listings: [PFObject] = [PFObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.hidesBarsOnSwipe = true
        
        self.fetchListings()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func fetchListings() {
        var query = PFQuery(className: "Listing")
        query.orderByDescending("createdAt")
        query.findObjectsInBackgroundWithBlock { (objects: [AnyObject]!, error: NSError!) -> Void in
            if let downcastedObjects = objects as? [PFObject] {
                // Add listings to array
                self.listings.removeAll(keepCapacity: false)
                self.listings += downcastedObjects
                self.collectionView?.reloadData()
            }
        }
    }
    
    @IBAction func refreshListings(sender: AnyObject) {
        self.fetchListings()
    }
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 8
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("listingViewCell", forIndexPath: indexPath) as NewListingsViewCell
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        var spacing:CGFloat = 30.0
        
        // Calculate Width
        var screenWidth = UIScreen.mainScreen().bounds.size.width
        var width:CGFloat = (screenWidth - spacing) / 2.0
        
        // Calculate Height
        var tabBar:CGFloat = (self.tabBarController?.tabBar.frame.height)!
        var navBar:CGFloat = (self.navigationController?.navigationBar.frame.height)!
        
        var height:CGFloat
        if screenWidth > 320 {
            height = (self.view.bounds.size.height - (spacing + tabBar + navBar)) / 2.3
        } else {
            height = (self.view.bounds.size.height - (spacing + tabBar + navBar)) / 2.1
            
        }
        
        
        return CGSizeMake(width, height)
    }}