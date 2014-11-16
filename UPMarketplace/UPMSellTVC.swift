//
//  UPMSellTVC.swift
//  UPMarketplace
//
//  Created by John Liedtke on 11/8/14.
//  Copyright (c) 2014 UP Marketplace. All rights reserved.
//

import UIKit
import SellUI

class UPMSellTVC: UITableViewController, UPMSellDescriptionDelegate, UITextViewDelegate, UPMSellPriceFormatDelegate {
  let SellCellIdentifier = "UPMSellCell"
 
  var requiredItems = UPMSellItemContainer()

  enum CellSection: Int {
    case Required = 0, Optional;
    static let allValues = [Required, Optional]
  }

  enum RequiredItems: String {
    case Photos = "Photos"
    case Description = "Description"
    case PriceFormat = "Price Format"
    case Details = "Details"
    static let allValues = [Photos,Description, PriceFormat, Details]
  }
  

  
  var listing: UPMListing?
  
  func post() {
    
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    listing = UPMListing()

    tableView.estimatedRowHeight = 60
    tableView = UITableView(frame: tableView.frame, style: UITableViewStyle.Grouped)
   
    
    // Required
    createRequiredItems()
 
    
    // UPMSellCell
    tableView.registerNib(UINib(nibName: SellCellIdentifier, bundle: nil), forCellReuseIdentifier: SellCellIdentifier)

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
    var photoItem = UPMSellItem(title: RequiredItems.Photos.rawValue, description: "Select")
    var priceFormatItem = UPMSellItem(title: RequiredItems.PriceFormat.rawValue, description: "Select")
    var detailsItem = UPMSellItem(title: RequiredItems.Details.rawValue, description: "Select")
    var descriptionItem = UPMSellItem(title: RequiredItems.Description.rawValue, description: "Write")
    requiredItems.addItems([photoItem, priceFormatItem, detailsItem, descriptionItem])
    
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
      // Dispose of any resources that can be recreated.
  }

  // MARK: - Table view data source

  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return CellSection.allValues.count
  }

  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    let Section = CellSection(rawValue: section)
    
    switch Section! {
    case CellSection.Required:
      return requiredItems.count
    default:
      return 0
    }
  }

  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier(SellCellIdentifier, forIndexPath: indexPath) as UPMSellCell
    
    let Section: CellSection = (CellSection(rawValue: 0))! as CellSection
    
      switch Section {
      case CellSection.Required:
        var i = requiredItems.itemAtIndex(indexPath.row)
        cell.configureCell(i.title, details: i.itemDescription, isComplete: i.isComplete)
        return cell
        
      default:
        NSLog("meow")
      }
      return cell
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
    var priceFormatItem = requiredItems.itemWithTitle(RequiredItems.PriceFormat.rawValue)
    priceFormatItem?.itemDescription = "Price: \(price) \(oBo)"
    priceFormatItem?.isComplete = true
  }
  

  
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    
    let Section: CellSection = (CellSection(rawValue: 0))! as CellSection
    
    
    switch Section {
    case CellSection.Required:
      var item = requiredItems.itemAtIndex(indexPath.row)

      switch item.title {
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
