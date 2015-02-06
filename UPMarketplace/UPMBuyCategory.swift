//
//  UPMBuyCategory.swift
//  UPMarketplace
//
//  Created by Krismy on 1/15/15.
//  Copyright (c) 2015 UP Marketplace. All rights reserved.
//



import UIKit

class UPMBuyCategory: UICollectionViewController,UICollectionViewDelegateFlowLayout{
    
  var categories = ["Textbooks", "Housing", "Furniture & Other"]
  var pictures = ["textbook.png", "housing.png", "furniture.png"]

  let reuseidentifer = "BuyCategoryCell"

  override func viewDidLoad() {
      super.viewDidLoad()
    collectionView?.backgroundColor = UIColor.standardBackgroundColor()
    
    
  }

  override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
  }

  override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
      return 1
  }



  override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      return 3
  }

  override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
      let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseidentifer, forIndexPath: indexPath) as UPMBuyCategoryCell
      
      cell.pic = UIImage(named: pictures[indexPath.row])
      cell.title = categories[indexPath.row]
      
      
      return cell
  }
  

  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if(segue.identifier == "showBuyList"){

      
      let indexPath: NSIndexPath! = collectionView?.indexPathForCell(sender as UPMBuyCategoryCell)
      var category:String! = categories[indexPath.row]
      
      var sendCategory: String?
      if(category == "Housing"){
        sendCategory = "UPMHousingListing"
      }
      else if (category == "Textbooks"){
        sendCategory = "UPMTextbookListing"
      }
      else if (category == "Furniture & Other"){
        sendCategory = "UPMOtherListing"
      }
      let theDestination = (segue.destinationViewController as UPMBuyListItemsOtherCVC)
      theDestination.chosenCategory = sendCategory

      
    }
    
    
  }



}