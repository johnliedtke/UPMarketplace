//
//  UPMCategoryFilterMainTVC.swift
//  UPMarketplace
//
//  Created by Krismy on 2/21/15.
//  Copyright (c) 2015 UP Marketplace. All rights reserved.
//

import UIKit

//struct Filter<C,T> {
//  var category: T
//  var tags: [C]?
//  var condition: String?
//}


protocol UPMFilterDelegate: class {
  func didFinishFiltering(sender: UPMCategoryFilterMainTVC, category: String)
}

class UPMCategoryFilterMainTVC: UITableViewController {

  // MARK: - Constants
  let filterCellIdentifier = "UPMBuyFilterCell"

  // MARK: - Public Properties
  var subCategories = [ " ", "Select Category: ", " ", " "]
  var clearButton:UIBarButtonItem?
  var chosenFilter: String?
  
  // Delegate
  weak var delegate: UPMFilterDelegate?
  
  // MARK: - View Methods
  // TODO: - Fix first cell hidden issue
  override func viewDidLoad() {
    super.viewDidLoad()
    self.tableView = tableView
    
    //register the filter cell nib
    tableView.registerNib(UINib(nibName: filterCellIdentifier, bundle: nil), forCellReuseIdentifier: filterCellIdentifier)
    
    // Auto-layout
    tableView.setTranslatesAutoresizingMaskIntoConstraints(false)
    tableView.estimatedRowHeight = 1000 // fix for auto-layout

    navigationItem.title = "*********************"
    navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .Done, target: self, action: "done")
  }
  
  func done() {
    delegate?.didFinishFiltering(self, category: "Furniture")
  }

  // MARK: - Table view data source

  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }

  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return subCategories.count
  }

  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier(filterCellIdentifier, forIndexPath: indexPath) as! UPMBuyFilterCell
    cell.configureCell(subCategories[indexPath.row])
    return cell
  }
  
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    //TODO: Fix the ignoring first row bug
    if(indexPath.row > 0){
      chosenFilter = subCategories[indexPath.row]
    }
  }

}
