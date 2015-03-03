//
//  UPMNewListingsFilter.swift
//  UPMarketplace
//
//  Created by Krismy on 2/21/15.
//  Copyright (c) 2015 UP Marketplace. All rights reserved.
//

import UIKit

class UPMNewListingsFilter: UITableViewController {

  //button that may be used to go back to orig view and clear the filter
  //MARK: - Button Action
  @IBAction func doneButton(sender: AnyObject) {
    var nav = storyboardS.instantiateViewControllerWithIdentifier("frontNav") as! UINavigationController
    var first: UPMBuyNewListingsGridCVC = nav.childViewControllers.first as! UPMBuyNewListingsGridCVC
   
    //change the filter back and change the title back to normal
    first.chosenCategory = -1
    first.titleTop = "New Listings"
    self.revealViewController().pushFrontViewController(nav, animated: true)
    
  }
   // MARK: - Public Properties
  var categories = ["Furniture & Other", "Housing", "Textbooks"]
  var chosenCategory: NSInteger?
  
  // MARK: - Constants
  let storyboardS = UIStoryboard(name: "UPMBuy", bundle: nil) //story board being used
  let filterCellIdentifier = "UPMBuyFilterCell"
  
  // MARK: - View Methods
    override func viewDidLoad() {
        super.viewDidLoad()
      
      //register the filterCell nib
        tableView.registerNib(UINib(nibName: filterCellIdentifier, bundle: nil), forCellReuseIdentifier: filterCellIdentifier)
      //set the title of filter
        navigationItem.title = "Filter"

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {

        return 1
    }

    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return categories.count
    }

  
   override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

    let cell = tableView.dequeueReusableCellWithIdentifier(filterCellIdentifier, forIndexPath: indexPath) as! UPMBuyFilterCell
    
    //configure the cells to be the category name
    cell.configureCell(categories[indexPath.row])
    return cell
   }

  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    
    //instantiate the front controller as the collection view for new listings
    var nav = storyboardS.instantiateViewControllerWithIdentifier("frontNav") as! UINavigationController
    var first: UPMBuyNewListingsGridCVC = nav.childViewControllers.first as! UPMBuyNewListingsGridCVC
   
    //change the values of the query and title based on selected row
    first.chosenCategory = indexPath.row
    first.titleTop = "Filtered by: " + categories[indexPath.row]
    self.revealViewController().pushFrontViewController(nav, animated: true)


  }

  

}
