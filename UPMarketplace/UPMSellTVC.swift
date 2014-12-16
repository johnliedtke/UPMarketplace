//
//  UPMSellTVC.swift
//  UPMarketplace
//
//  Created by John Liedtke on 11/8/14.
//  Copyright (c) 2014 UP Marketplace. All rights reserved.
//

import UIKit
import SellUI

class UPMSellTVC: UITableViewController, UPMSellDescriptionDelegate, UITextViewDelegate, UPMSellPriceFormatDelegate, UPMSellTitleDelegate, UPMSellImagePickerDelegate {
  let SellCellIdentifier = "UPMSellCell"
  let SellTitleCelIdentifier = "UPMSellTitleCell"
 
  var requiredItems = UPMSellItemContainer()
  var optionalItems = UPMSellItemContainer()
  var listing: UPMListing?
  
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
  
  func post() {
    if  requiredItems.isItemsComplete() {
      println("Complete")
    } else {
      println("Not complete!!!")
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    listing = UPMOtherListing()
    tableView.estimatedRowHeight = 60
    tableView = UITableView(frame: tableView.frame, style: UITableViewStyle.Grouped)
    tableView.backgroundColor = UIColor.standardBackgroundColor()
    
    addCancelButtontToNavigationItemWithSelector("didPressCancelButton:")
    var postButton = UIBarButtonItem(title: "Post", style: UIBarButtonItemStyle.Done, target: self, action: "didPressPostButton:")
    navigationItem.rightBarButtonItem = postButton
    self.automaticallyAdjustsScrollViewInsets = false
    
    self.edgesForExtendedLayout = UIRectEdge.All;
    self.tableView.contentInset = UIEdgeInsetsMake(0.0, 0.0, CGRectGetHeight((self.tabBarController?.tabBar.frame)!), 0.0)
    
    // Items
    createRequiredItems()
    createOptionalItems()
    
    // Cells
    tableView.registerNib(UINib(nibName: SellCellIdentifier, bundle: nil), forCellReuseIdentifier: SellCellIdentifier)
    tableView.registerNib(UINib(nibName: SellTitleCelIdentifier, bundle: nil), forCellReuseIdentifier: SellTitleCelIdentifier)

  }
  
  func didPressCancelButton(sender: AnyObject) {
    self.navigationController?.popToRootViewControllerAnimated(true)
  }
  
  func didPressPostButton(sender: AnyObject) {
    post()
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
        if listing?.photo != nil {
          cell.displayImageView.image = listing?.photo
        }

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
  
  override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    if section == 0 {
      return getNavigationBarHeight() + 30
    } else {
      return UITableViewAutomaticDimension
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
  
  func didUpdatePhoto(image: UIImage) {
    var photoItem = requiredItems.itemWithTitle(RequiredItems.Photos.rawValue)
    var file: NSData = UIImageJPEGRepresentation(image, 0.5)
    listing?.picture = PFFile(name: "image.png", data: file)
    listing?.photo = image
    photoItem?.itemDescription = "Picture Added"
    photoItem?.isComplete = true
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
      case RequiredItems.Photos.rawValue:
        pushImagePickerVC()
        
      case RequiredItems.Details.rawValue:
        pushDetailsVC()
        
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

}
