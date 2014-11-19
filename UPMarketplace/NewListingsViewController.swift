//
//  NewListingsViewController.swift
//  UPMarketplace
//
//  Created by Krismy on 11/15/14.
//  Copyright (c) 2014 UP Marketplace. All rights reserved.
//


import UIKit


class NewListingsViewController:UICollectionViewController, UICollectionViewDelegateFlowLayout {

    var listings: [PFObject] = [PFObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.queryListings()
    }
    

    func queryListings() {
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
    
    @IBAction func refreshListings(sender: AnyObject) {
        self.queryListings()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.listings.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("listingViewCell", forIndexPath: indexPath) as NewListingsViewCell
        
            var info = listings[indexPath.row] as PFObject
        
            var picture = info["photo"] as PFFile
            picture.getDataInBackgroundWithBlock { (data: NSData!, error: NSError!) -> Void in
                var actualImage = UIImage(data: data)
                cell.image = nil
                cell.image = actualImage
            }
        
            cell.title = info["title"] as? String
            cell.price = info["price"] as? String
    
        return cell
    }
    

}