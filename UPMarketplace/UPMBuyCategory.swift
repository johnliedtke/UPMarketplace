//
//  UPMBuyCategory.swift
//  UPMarketplace
//
//  Created by Krismy on 1/15/15.
//  Copyright (c) 2015 UP Marketplace. All rights reserved.
//



import UIKit

class UPMBuyCategory: UICollectionViewController,UICollectionViewDelegateFlowLayout{
  
  // TODO: Fix Bug With pressing back button, the collectionview ends up hiding behind the navigation bar
  
  // MARK: - Public Properties
  var categories = ["Furniture & Other", "Housing", "Textbooks"]
  var pictures = [ "other.png","house.png", "books.png"]
  var classes = ["UPMOtherListing", "UPMHousingListing", "UPMTextbookListing"]
  var className: String?
  var allCategory = [" "]
  
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
    revController.setRightViewController(buyFilter, animated: true)
    
    // Calculate Height
    var TabBarHeight:CGFloat = (self.tabBarController?.tabBar.frame.height)!
    var NavBarHeight:CGFloat = (self.navigationController?.navigationBar.frame.height)!
    
    
    //make tableview fit in the right bounds
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
        
         //get the subcategories for selected class
        className = classes[indexPath.row]
        getCategories(className!)
        
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
        
        //get the subcategories for selected class
       // className = classes[indexPath.row]
        //getCategories(className!)
        
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
        
        //get the subcategories for selected class
        //className = classes[indexPath.row]
        //getCategories(className!)
        
        
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
  
  
  
  // MARK: - Private Methods
  
  func getCategories(classQuery: String){
    //get the unique subcategories from the selected class and initalize it for the filter tableview to use
    var query = PFQuery(className: classQuery)
    query.selectKeys(["category"])
    
    query.findObjectsInBackgroundWithBlock {
      (objects: [AnyObject]!, error: NSError!) -> Void in
      if error == nil {

        // add them to the array of subcategories
        if let objects = objects as? [PFObject] {
          for object in objects {
            if(!contains(self.allCategory, object["category"] as! String)){
              self.allCategory.append(object["category"] as! String)
            }
          }
        } else {
          // Log details of the failure
          // println("Error: \(error) \(error.userInfo!)")
        }
        
        //make them alphabetized
        self.allCategory = self.allCategory.sorted { $0.localizedCaseInsensitiveCompare($1) == NSComparisonResult.OrderedAscending }
        self.buyFilter.subCategories = self.allCategory
        
        
      }
      
    }
  }
}






