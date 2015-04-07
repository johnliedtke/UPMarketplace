//
//  UPMNewListingsFilter.swift
//  UPMarketplace
//
//  Created by Krismy on 2/21/15.
//  Copyright (c) 2015 UP Marketplace. All rights reserved.
//

import UIKit

protocol NewListingsFilter: class {
 // didSelectFilter(
}

class UPMNewListingsFilter: UITableViewController {

  //button that may be used to go back to orig view and clear the filter
  //MARK: - Button Action
  @IBAction func doneButton(sender: AnyObject) {
    var nav = storyboardS.instantiateViewControllerWithIdentifier("frontNav") as UINavigationController
    var first: UPMBuyNewListingsGridCVC = nav.childViewControllers.first as UPMBuyNewListingsGridCVC
   
    //change the filter back and change the title back to normal
    first.chosenCategory = -1
    first.titleTop = "New Listings"
    self.revealViewController().pushFrontViewController(nav, animated: true)
    
  }
  // MARK: - Public Properties
  var categories = ["Furniture & Other", "Housing (Coming soon)", "Textbooks"]
  var chosenCategory: NSInteger?
  
  // MARK: - Constants
  let storyboardS = UIStoryboard(name: "UPMBuy", bundle: nil) //story board being used
  let filterCellIdentifier = "UPMBuyFilterCell"
  
  // MARK: - Private Properties
  lazy var dataSource: SingleSectionDataSource<String> = {
    var rows = ["Furniture & Other", "Housing (Coming soon)", "Textbooks"]
    var ds = SingleSectionDataSource(rows: rows, cellConfigurator: { (cell, string) in
      cell.textLabel?.textAlignment = NSTextAlignment.Right
      cell.textLabel?.text = string
    })
    return ds
  }()
  
  // MARK: - View Methods
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.dataSource = dataSource.tableViewDataSource
    
    //set the title of filter
    navigationItem.title = "Filter"

  }

  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

    //instantiate the front controller as the collection view for new listings
    var nav = storyboardS.instantiateViewControllerWithIdentifier("frontNav") as UINavigationController
    var first: UPMBuyNewListingsGridCVC = nav.childViewControllers.first as UPMBuyNewListingsGridCVC
   
    //change the values of the query and title based on selected row
    first.chosenCategory = indexPath.row
    first.titleTop = categories[indexPath.row]
    self.revealViewController().pushFrontViewController(nav, animated: true)
  }

  

}
