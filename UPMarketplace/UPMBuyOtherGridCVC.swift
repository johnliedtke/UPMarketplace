//
//  UPMBuyOtherGridCVC.swift
//  UPMarketplace
//
//  Created by John Liedtke on 12/21/14.
//  Copyright (c) 2014 UP Marketplace. All rights reserved.
//

import UIKit

//TODO: Implement the class...

/**
  The UPMBuyOtherGridCVC displays all UPMOtherListing currently on Parse.
*/
class UPMBuyOtherGridCVC: UPMBuyGridCVC {

    var chosenCategory: String?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func changeDefaults() {
    }
    
    
    override func query() -> PFQuery {
        var listingQuery = PFQuery(className: chosenCategory)
        listingQuery.orderByDescending("createdAt")
        return listingQuery
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath, object: PFObject) -> UICollectionViewCell {
        
        let cellItem = collectionView.dequeueReusableCellWithReuseIdentifier("UPMItemsCategoryCell", forIndexPath: indexPath) as UPMItemCategoryCell
        
        let listingDetails = object as UPMListing
        
        // Grab the picture-file and retrieve it from parse
        var picture = object["picture"] as? PFFile
        cellItem.itemImage.file = listingDetails.picture
        cellItem.itemImage.loadInBackground()
        
        //TODO: Change details
        cellItem.configureCell(listingDetails.title, price: listingDetails.displayPrice(), details: "Reserve Now")
        
        return cellItem
    }
    
    func collectionView(collection: UICollectionView, selectedItemIndex: NSIndexPath)
    {
        self.performSegueWithIdentifier("viewItemDetail", sender: self)
    }
    
//    override func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
//       // var listing = objects[indexPath.row]
//    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "viewItemDetail"){
            
            let indexPaths : NSArray = self.collectionView.indexPathsForSelectedItems()!
            let indexPath : NSIndexPath = indexPaths[0] as NSIndexPath
            var listing = objects[indexPath.row]["picture"] as? PFFile
            
           // var pic = listing["photo"] as PFFile
            //pic.getDataInBackgroundWithBlock { (data: NSData!, error: NSError!) -> Void in
            //    var actualImage = UIImage(data: data)
                
                
            let destinationVC = segue.destinationViewController as UPMBuyItemDetailsTVC
        //    destinationVC.selectedImage.file = listing
            //let info = self.collectionView(collectionView, cellForItemAtIndexPath: indexPath, object: 
            //objects[indexPath.row]) as UPMItemCategoryCell
           
            //var pic = listing["picture"] as? UPMItemCategoryCell
            //destinationVC.selectedImage = listing.photo
            
            
        }

    }


}
