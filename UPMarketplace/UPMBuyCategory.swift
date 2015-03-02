//
//  UPMBuyCategory.swift
//  UPMarketplace
//
//  Created by Krismy on 1/15/15.
//  Copyright (c) 2015 UP Marketplace. All rights reserved.
//



import UIKit

class UPMBuyCategory: UICollectionViewController,UICollectionViewDelegateFlowLayout{
  
  // TODO: Fix Bug With pressing back button
  
  // MARK: - Public Properties
  var categories = ["Furniture & Other", "Housing", "Textbooks"]
  var pictures = [ "other.png","house.png", "books.png"]
  
  // MARK: - Constants
  let buyFilter = UPMCategoryFilterMainTVC()
  let reuseidentifer = "BuyCategoryCell"
  let revController = SWRevealViewController()
  
  
  // MARK: - View Methods
  override func viewDidLoad() {
    super.viewDidLoad()
    collectionView?.backgroundColor = UIColor.standardBackgroundColor()
    
    //set default behavior of reveal controller
    revController.bounceBackOnOverdraw = true;
    revController.stableDragOnOverdraw = true;
    revController.rightViewController = buyFilter
    
    // Calculate Height
    var TabBarHeight:CGFloat = (self.tabBarController?.tabBar.frame.height)!
    var NavBarHeight:CGFloat = (self.navigationController?.navigationBar.frame.height)!
    
    buyFilter.tableView.clipsToBounds = true
    buyFilter.tableView.contentInset = UIEdgeInsetsMake(TabBarHeight + NavBarHeight, 0.0, 0.0, 0.0)
  }

  override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
  }

  // MARK: - Collectionview Datasource
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
        
        //set defaults of each controller
        var buyCategory = UPMBuyListItemsOtherCVC(collectionViewLayout: UICollectionViewFlowLayout())
        revController.frontViewController = buyCategory
        revController.setFrontViewPosition(FrontViewPosition.Right, animated: true)
        
        //set the title to be that of the chosen category
        revController.navigationItem.title = categories[indexPath.row]
        buyCategory.category = categories[indexPath.row]
        
        //create the filter button in the navigation bar
        var filterButton = UIBarButtonItem(title: "Filter", style: .Plain, target: buyCategory, action:Selector("goToRear"))
        revController.navigationItem.rightBarButtonItem = filterButton
        
        //push the reveal controller
        navigationController?.pushViewController(revController, animated: true)
        break
      
      case 1:
        //set defaults of each controller
        var buyCategory = UPMBuyListItemsHousingCVC(collectionViewLayout: UICollectionViewFlowLayout())
        revController.frontViewController = buyCategory
        revController.setFrontViewPosition(FrontViewPosition.Right, animated: true)
        
        //set the title to be that of the chosen category
        revController.navigationItem.title = categories[indexPath.row]
        buyCategory.category = categories[indexPath.row]
        
        //create the filter button in the navigation bar
        var filterButton = UIBarButtonItem(title: "Filter", style: .Plain, target: buyCategory, action:Selector("goToRear"))
        revController.navigationItem.rightBarButtonItem = filterButton
        
        //push the reveal controller
        navigationController?.pushViewController(revController, animated: true)
        break
      case 2:
      
        //set defaults of each controller
        var buyCategory = UPMBuyListItemsTextbookCVC(collectionViewLayout: UICollectionViewFlowLayout())
        revController.frontViewController = buyCategory
        revController.setFrontViewPosition(FrontViewPosition.Right, animated: true)
        
        //set the title to be that of the chosen category
        revController.navigationItem.title = categories[indexPath.row]
        buyCategory.category = categories[indexPath.row]
        
        //create the filter button in the navigation bar
        var filterButton = UIBarButtonItem(title: "Filter", style: .Plain, target: buyCategory, action:Selector("goToRear"))
        revController.navigationItem.rightBarButtonItem = filterButton
        
        //push the reveal controller
        navigationController?.pushViewController(revController, animated: true)
        
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


  



