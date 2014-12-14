//
//  UPMSellDetailsTVC.swift
//  UPMarketplace
//
//  Created by John Liedtke on 11/20/14.
//  Copyright (c) 2014 UP Marketplace. All rights reserved.
//

import UIKit
import SellUI

protocol UPMSellDetailsTVCDelegate {
  func didDetailsUpdate(details: String, isComplete: Bool)
}


class UPMSellDetailsTVC: UITableViewController {
  let SellCellIdentifier = "UPMSellCell"
  
  enum CellSection: Int {
    case Required , Optional;
    static let allValues = [Required, Optional]
  }
  
  var listing: UPMListing?
  var delegate: UPMSellDetailsTVCDelegate?
  var requiredItems = UPMSellItemContainer()
  var optionalItems = UPMSellItemContainer()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    createRequiredItems()
    createOptionalItems()
    tableView = UITableView(frame: tableView.frame, style: UITableViewStyle.Grouped)
    view.backgroundColor = UIColor.standardBackgroundColor()
    navigationItem.title = "Details"

    
    // Cells
    tableView.registerNib(UINib(nibName: SellCellIdentifier, bundle: nil), forCellReuseIdentifier: SellCellIdentifier)
  }
    
  func createRequiredItems() {
    
  }
  
  func createOptionalItems() {
    
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    tableView.reloadData()
  }
  
  override func viewWillDisappear(animated: Bool) {
    super.viewWillDisappear(animated)
    delegate?.didDetailsUpdate(requiredItems.description(), isComplete: requiredItems.isItemsComplete())
  }
  
  // MARK: - Table view data source

  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return CellSection.allValues.count
  }

  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    let Section = CellSection(rawValue: section)!
    switch Section {
    case CellSection.Required:
      return requiredItems.count
    case CellSection.Optional:
      return optionalItems.count
    default:
      return 0
    }
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCellWithIdentifier(SellCellIdentifier, forIndexPath: indexPath) as UPMSellCell

    let item = requiredItems.itemAtIndex(indexPath.row)
    cell.configureCell(item.title, details: item.itemDescription, isComplete: item.isComplete)

      return cell
  }
  
  override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    let s = CellSection(rawValue: section)!
    switch s {
    case CellSection.Required:
      return "Required"
    case CellSection.Optional where optionalItems.count > 0:
      return "Optional"
    default:
      return ""
    }
  }
  
  func didSelectItem(item: UPMSellItem) {
    
  }
  
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    let Section = CellSection(rawValue: indexPath.section)!
    switch Section {
    case CellSection.Required:
      let requiredItem = requiredItems.itemAtIndex(indexPath.row)
      didSelectItem(requiredItem)
    case CellSection.Optional where optionalItems.count > 0:
      let optionalItem = requiredItems.itemAtIndex(indexPath.row)
      didSelectItem(optionalItem)
    default:
      println("Deafult")
    }
  }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
