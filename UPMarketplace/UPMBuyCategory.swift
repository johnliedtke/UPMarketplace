//
//  UPMBuyCategory.swift
//  UPMarketplace
//
//  Created by Krismy on 1/15/15.
//  Copyright (c) 2015 UP Marketplace. All rights reserved.
//



import UIKit

class UPMBuyCategory: UICollectionViewController,UICollectionViewDelegateFlowLayout{
    
  var categories = ["Textbooks", "Housing", "Other"]
  var pictures = ["NewSelected.png", "NewSelected.png", "NewSelected.png"]

  let reuseidentifer = "BuyCategoryCell"

  override func viewDidLoad() {
      super.viewDidLoad()
      
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

  func collectionView(collection: UICollectionView, selectedItemIndex: NSIndexPath)
  {
      
      self.performSegueWithIdentifier("choseCategory", sender: self)
  }

  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
      if (segue.identifier == "choseCategory"){
          
          let indexPaths : NSArray = (self.collectionView?.indexPathsForSelectedItems())!
          let indexPath : NSIndexPath = indexPaths[0] as NSIndexPath
          
          var chosenCategory = categories[indexPath.row]
          let destinationVC = segue.destinationViewController as UPMBuyOtherGridCVC
          if (chosenCategory == categories[2]){
          
              destinationVC.chosenCategory = "UPMOtherListing"
          }
          else{
              destinationVC.chosenCategory = "Listing"
          }
          
          
          
          
          
      }
  }



}