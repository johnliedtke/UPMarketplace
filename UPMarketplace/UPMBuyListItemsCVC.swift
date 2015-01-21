//
//  UPMBuyListItemsCVC.swift
//  UPMarketplace
//
//  Created by Krismy on 1/19/15.
//  Copyright (c) 2015 UP Marketplace. All rights reserved.
//

import UIKit

class UPMBuyListItemsCVC: UPMBuyGridCVC {
  
    //TODO: Change query to retrieve the three major UPMListing types.
    override func query() -> PFQuery {
        var listQuery = PFQuery(className: "UPMOtherListing")
        listQuery.orderByDescending("createdAt")
        return listQuery
    }
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
    
        override func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
           var listing = objects[indexPath.row]
           //var picture = listing["picture"] as? PFFile
           // var title = listing["title"] as? String
        self.performSegueWithIdentifier("viewItemDetail", sender: self)
            
        }
//    func collectionView(collection: UICollectionView, selectedItemIndex: NSIndexPath)
//    {
//        self.performSegueWithIdentifier("viewItemDetail", sender: self)
//    }
    
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        if (segue.identifier == "viewItemDetail"){
//            
//            let indexPaths : NSArray = (self.collectionView.indexPathsForSelectedItems())!
//            let indexPath : NSIndexPath = indexPaths[0] as NSIndexPath
//            
//            var listing = objects[indexPath.row]
//            let destinationVC = segue.destinationViewController as UPMBuyItemDetailsTVC
//            
//            
//
//        }
//    }


    
}