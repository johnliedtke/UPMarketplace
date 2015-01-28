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
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath, withObject object: PFObject) -> Void {
        
//        var listing = object as UPMListing
//        
//        let BuyItem = UIStoryboard(name: "UPMBuyWorkflow", bundle: nil)
//        var buyCategoryVC = BuyItem.instantiateViewControllerWithIdentifier("UPMBuyList")
//        buyCategoryVC.chosenCategory = listing
//        
//        //var picture = listing["picture"] as? PFFile
//        // var title = listing["title"] as? String
//        self.performSegueWithIdentifier("viewItemDetail", sender: self)
    }




}