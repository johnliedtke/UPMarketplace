//
//  UPMSellHomeTVC.swift
//  UPMarketplace
//
//  Created by John Liedtke on 4/6/15.
//  Copyright (c) 2015 UP Marketplace. All rights reserved.
//

import UIKit

class UPMSellHomeTVC: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
  
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    if indexPath.row == 0 {
      let furnitureOtherTVC = UPMSellOtherTVC()
      navigationController?.pushViewController(furnitureOtherTVC, animated: true)
    } else if indexPath.row == 2 {
      let textbookTVC = UPMSellTextbookTVC()
      navigationController?.pushViewController(textbookTVC, animated: true)
    }
  }
  


}
