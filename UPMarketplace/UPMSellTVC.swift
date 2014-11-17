//
//  UPMSellTVC.swift
//  UPMarketplace
//
//  Created by John Liedtke on 11/8/14.
//  Copyright (c) 2014 UP Marketplace. All rights reserved.
//

import UIKit
import SellUI

class UPMSellTVC: UITableViewController, UPMSellDescriptionDelegate, UITextViewDelegate, UPMSellPriceFormatDelegate, UPMSellTitleDelegate {
  let SellCellIdentifier = "UPMSellCell"
  let SellTitleCelIdentifier = "UPMSellTitleCell"
 
  var requiredItems = UPMSellItemContainer()
  var optionalItems = UPMSellItemContainer()

  enum CellSection: Int {
    case Title = 0, Required , Optional;
    static let allValues = [Title, Required, Optional]
  }

  enum RequiredItems: String {
    case Title = "Title"
    case Photos = "Photos"
    case Description = "Description"
    case PriceFormat = "Price Format"
    case Details = "Details"
    static let allValues = [Photos,Description, PriceFormat, Details]
  }
  
  enum OptionalItems: String {
    case Tags = "Tags"
  }
  

  
  var listing: UPMListing?
  
  func post() {
    
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    listing = UPMListing()
    self.tableView.backgroundView = nil
    self.tableView.backgroundColor = UIColor.redColor()
    view.backgroundColor = UIColor.blackColor()
   
    tableView.estimatedRowHeight = 60
    tableView = UITableView(frame: tableView.frame, style: UITableViewStyle.Grouped)
    
    // Items
    createRequiredItems()
    createOptionalItems()
    
    // Cells
    tableView.registerNib(UINib(nibName: SellCellIdentifier, bundle: nil), forCellReuseIdentifier: SellCellIdentifier)
    tableView.registerNib(UINib(nibName: SellTitleCelIdentifier, bundle: nil), forCellReuseIdentifier: SellTitleCelIdentifier)

  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    tableView.reloadData()
    
  }
  
  func createRequiredItems() {
    // Required
    var titleItem = UPMSellItem(title: RequiredItems.Title.rawValue, description: "Write")
    var photoItem = UPMSellItem(title: RequiredItems.Photos.rawValue, description: "Select")
    var priceFormatItem = UPMSellItem(title: RequiredItems.PriceFormat.rawValue, description: "Select")
    var detailsItem = UPMSellItem(title: RequiredItems.Details.rawValue, description: "Select")
    var descriptionItem = UPMSellItem(title: RequiredItems.Description.rawValue, description: "Write")
    requiredItems.addItems([titleItem, photoItem, priceFormatItem, detailsItem, descriptionItem])
  }
  
  func createOptionalItems() {
    var tagsItem = UPMSellItem(title: OptionalItems.Tags.rawValue, description: "Select")
    optionalItems.addItems([tagsItem])
  }

  // MARK: - Table view data source

  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return CellSection.allValues.count
  }

  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    let Section = CellSection(rawValue: section)
    
    switch Section! {
    case CellSection.Title:
      return 1
    case CellSection.Required:
      return requiredItems.count
    case CellSection.Optional:
      return optionalItems.count
    default:
      return 0
    }
  }
  
  override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    let s = CellSection(rawValue: section)!
    switch s {
    case CellSection.Required:
      return "Required"
    case CellSection.Optional:
      return "Optional"
    default:
      return ""
    }
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
    
    let Section: CellSection = (CellSection(rawValue: indexPath.section))! as CellSection
    
      switch Section {
      case CellSection.Title:
        let cell = tableView.dequeueReusableCellWithIdentifier(SellTitleCelIdentifier, forIndexPath: indexPath) as UPMSellTitleCell
        var titleItem = requiredItems.itemWithTitle(RequiredItems.Title.rawValue)
        cell.titleLabel.text = titleItem?.itemDescription
        return cell
      case CellSection.Required:
        let cell = tableView.dequeueReusableCellWithIdentifier(SellCellIdentifier, forIndexPath: indexPath) as UPMSellCell
        var i = requiredItems.itemAtIndex(indexPath.row)
        cell.configureCell(i.title, details: i.itemDescription, isComplete: i.isComplete)
        return cell
      case CellSection.Optional:
        let cell = tableView.dequeueReusableCellWithIdentifier(SellCellIdentifier, forIndexPath: indexPath) as UPMSellCell
        var i = optionalItems.itemAtIndex(indexPath.row)
        cell.configureCell(i.title, details: i.itemDescription, isComplete: i.isComplete)
        return cell
      default:
        NSLog("meow")
      }
  }
  
  /*
  * Delegate Methods
  */
  func descriptionUpdated(description: String)  {
    var descriptionItem = requiredItems.itemWithTitle(RequiredItems.Description.rawValue)
    if description != "" {
      descriptionItem?.isComplete = true
      descriptionItem?.itemDescription = description
      listing?.descriptionS = description
    }
  }
  
  func updatedPriceFormat(price: Double, limit: Double?, oBo: Bool) {
    listing?.price = price
    if oBo {
      listing?.limit = limit!
    } else {
      listing?.limit = 0.00
    }
    listing?.oBO = oBo
    
    var priceFormatItem = requiredItems.itemWithTitle(RequiredItems.PriceFormat.rawValue)
    var descriptionString = ""
    if oBo {
      descriptionString = String(format: "Best Offer, Reserve $%.2f \nDecline offers lower than: $%.2f", price,limit!)
    } else {
      descriptionString = String(format: "Reserve $%.2f", price)
    }
    priceFormatItem?.itemDescription = descriptionString
    priceFormatItem?.isComplete = true
  }
  
  func didUpdateTitle(title: String) {
    var titleItem = requiredItems.itemWithTitle(RequiredItems.Title.rawValue)
    listing?.title = title
    titleItem?.itemDescription = title
    titleItem?.isComplete = true
  }
  
  func didSelectItemAtIndexPath(indexPath: NSIndexPath) {
    let Section: CellSection = (CellSection(rawValue: indexPath.section))! as CellSection
    
    
    switch Section {
    case CellSection.Required:
      var item = requiredItems.itemAtIndex(indexPath.row)
      
      switch item.title {
      case RequiredItems.Title.rawValue:
        pushTitleVC()
        
      case RequiredItems.PriceFormat.rawValue:
        pushPriceFormatVC()
        
      case RequiredItems.Description.rawValue:
        pushDescriptionVC()
        
      default:
        NSLog("meow")
      }
      
    default:
      NSLog("meow")
    }

    
  }
  
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    didSelectItemAtIndexPath(indexPath)
  }
  
  

  
  // MARK: - Navigation

  // In a storyboard-based application, you will often want to do a little preparation before navigation
//  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//      // Get the new view controller using [segue destinationViewController].
//      // Pass the selected object to the new view controller.
//    
//    
//    let SegueIdentifier = segue.identifier as String!
//    let DestinstionController = segue.destinationViewController as UIViewController
//    
//    switch SegueIdentifier {
//    case SellDescriptionSegue:
//      var descriptionVC = DestinstionController as UPMSellDescriptionVC
//      descriptionVC.descriptionS = "fuck this shit"
//      descriptionVC.delegate = self
//    case SellPriceFormatSegue:
//      var priceFormatVC = DestinstionController as UPMSellPriceFormatVC
//      priceFormatVC.delegate = self
//    default:
//      NSLog("Meow")
//
//    }
//    
//  }
  

}
