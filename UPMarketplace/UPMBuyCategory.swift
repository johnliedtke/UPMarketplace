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
  var pictures = ["books.png", "house.png", "other.png"]

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
     //   navigationController?.performSegueWithIdentifier("sw_front", sender: UPMBuyCategoryCell.self)
        
        navigationController?.pushViewController(viewController, animated: true)
        break
      case 1:
        var viewController = UPMBuyListItemsHousingCVC(collectionViewLayout: UICollectionViewFlowLayout())
        navigationController?.pushViewController(viewController, animated: true)
        break
      case 2:
        var revealController = SWRevealViewController(rearViewController: UPMCategoryFilterMainTVC(), frontViewController: UPMBuyListItemsOtherCVC(collectionViewLayout: UICollectionViewFlowLayout()))
        
        
        revealController.rightViewRevealWidth = 100;
        revealController.rightViewRevealOverdraw = 120;
        revealController.bounceBackOnOverdraw = true;
        revealController.stableDragOnOverdraw = true;
        revealController.setFrontViewPosition(FrontViewPosition.Left, animated: true)
        //revealController.delegate = self

        

        var viewController = UPMBuyListItemsOtherCVC(collectionViewLayout: UICollectionViewFlowLayout())
        navigationController?.pushViewController(revealController, animated: true)
        break
      default:
        break
    }
  }
  

  /**
  Create the grid into an aproximately 2 x 2.1 format. Adustments are made based on the
  resolution of the screen. The cell height shrinks as the screen size grows.
  */
  func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
    
    // Left + Right + In Between
    let Spacing:CGFloat = 30.0
    
    // Calculate Width
    let ScreenWidth = UIScreen.mainScreen().bounds.size.width
    let Width:CGFloat = (ScreenWidth - Spacing)
    
    // Calculate Height
    var TabBarHeight:CGFloat = (self.tabBarController?.tabBar.frame.height)!
    var NavBarHeight:CGFloat = (self.navigationController?.navigationBar.frame.height)!
    
    var height:CGFloat
    if ScreenWidth > 320 {
      height = (self.view.bounds.size.height - (Spacing + TabBarHeight + NavBarHeight)) / 3.15
    } else {
      height = (self.view.bounds.size.height - (Spacing + TabBarHeight + NavBarHeight)) / 3.00
    }
    
    return CGSizeMake(Width, height)
  }
}


  



