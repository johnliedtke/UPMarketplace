//
//  UPMCategoryFilterMainTVC.swift
//  UPMarketplace
//
//  Created by Krismy on 2/21/15.
//  Copyright (c) 2015 UP Marketplace. All rights reserved.
//

import UIKit

class UPMCategoryFilterMainTVC: UITableViewController {

  // MARK: - Constants
   let filterCellIdentifier = "UPMBuyFilterCell"
  
  
  // MARK: - Public Properties
  var subCategories = [ " ", "Select Category: ", " ", " "]
  var clearButton:UIBarButtonItem?
  var chosenFilter: String?
  
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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
     // Return the number sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      
        // Return the number of rows in the section.
        return subCategories.count
      
    }

  
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
      
      let cell = tableView.dequeueReusableCellWithIdentifier(filterCellIdentifier, forIndexPath: indexPath) as! UPMBuyFilterCell
      
           
      //configure the cells to be the category name
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
