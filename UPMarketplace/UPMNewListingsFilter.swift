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
    self.revealViewController().revealToggle(self)
  }
  
  var categories = ["Furniture & Other", "Housing", "Textbooks"]
  let filterCellIdentifier = "UPMBuyFilterCell"
  
    override func viewDidLoad() {
        super.viewDidLoad()
      tableView.registerNib(UINib(nibName: filterCellIdentifier, bundle: nil), forCellReuseIdentifier: filterCellIdentifier)

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




        override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
  

}
