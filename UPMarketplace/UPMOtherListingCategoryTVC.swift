//
//  UPMOtherListingCategoryTVC.swift
//  UPMarketplace
//
//  Created by John Liedtke on 11/20/14.
//  Copyright (c) 2014 UP Marketplace. All rights reserved.
//

import UIKit
import SellUI

protocol UPMOtherListingCategoryDelegate {
  func didUpdateCategory(category: String?)
}

class UPMOtherListingCategoryTVC: UITableViewController {
  
  let CategoryCellIdentifer = "UPMOtherListingCategoryCell"
  var delegate: UPMOtherListingCategoryDelegate?

  var categories: [String] = [String]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    categories += ["Appliances", "Bedroom", "Bikes", "Clothing", "Furniture and Decor",
      "Kitchen and Dining", "Patio and Outdoor Furniture", "School Supplies"]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
      return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return categories.count
    }

  
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(CategoryCellIdentifer, forIndexPath: indexPath) as UPMOtherListingCategoryCell
      
      cell.categoryLabel.text = categories[indexPath.row]
        return cell
    }
  
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    delegate?.didUpdateCategory(categories[indexPath.row])
    navigationController?.popViewControllerAnimated(true)
  }
  


}
