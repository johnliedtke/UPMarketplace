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
      let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseidentifer, forIndexPath: indexPath) as! UPMBuyCategoryCell
      
      cell.pic = UIImage(named: pictures[indexPath.row])
      cell.title = categories[indexPath.row]
      
      
      return cell
  }
  
  override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {

    //push the controller to the different class based on the category that was chosen
    switch(indexPath.row){
      case 0:
        var viewController = UPMBuyListItemsTextbookCVC(collectionViewLayout: UICollectionViewFlowLayout())
        navigationController?.pushViewController(viewController, animated: true)
        break
      case 1:
        var viewController = UPMBuyListItemsHousingCVC(collectionViewLayout: UICollectionViewFlowLayout())
        navigationController?.pushViewController(viewController, animated: true)
        break
      case 2:
        var viewController = UPMBuyListItemsOtherCVC(collectionViewLayout: UICollectionViewFlowLayout())
        navigationController?.pushViewController(viewController, animated: true)
        break
      default:
        break
    }
    
  }
    

}

    
  



