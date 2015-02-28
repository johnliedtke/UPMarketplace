//
//  UPMNewListingsFilter.swift
//  UPMarketplace
//
//  Created by Krismy on 2/21/15.
//  Copyright (c) 2015 UP Marketplace. All rights reserved.
//

import UIKit

class UPMNewListingsFilter: UITableViewController {

  //button that may be used to go back to orig view
  @IBAction func doneButton(sender: AnyObject) {
    var nav = storyboardS.instantiateViewControllerWithIdentifier("frontNav") as! UINavigationController
    var first: UPMBuyNewListingsGridCVC = nav.childViewControllers.first as! UPMBuyNewListingsGridCVC
    
    first.chosenCategory = -1
    first.titleTop = "New Listings"

    self.revealViewController().pushFrontViewController(nav, animated: true)
    
  }
  
  var categories = ["Furniture & Other", "Housing", "Textbooks"]
  let filterCellIdentifier = "UPMBuyFilterCell"
  var chosenCategory = -1
  let storyboardS = UIStoryboard(name: "UPMBuy", bundle: nil)
  
  
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.registerNib(UINib(nibName: filterCellIdentifier, bundle: nil), forCellReuseIdentifier: filterCellIdentifier)
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
    

    cell.configureCell(categories[indexPath.row])
    return cell
   }

  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    
    var nav = storyboardS.instantiateViewControllerWithIdentifier("frontNav") as! UINavigationController
    var first: UPMBuyNewListingsGridCVC = nav.childViewControllers.first as! UPMBuyNewListingsGridCVC
   
    first.chosenCategory = indexPath.row
    first.titleTop = "Filtered by: " + categories[indexPath.row]
    self.revealViewController().pushFrontViewController(nav, animated: true)


  }

  

}
