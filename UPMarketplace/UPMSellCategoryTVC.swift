//
//  UPMSellCategory.swift
//  UPMarketplace
//
//  Created by John Liedtke on 3/3/15.
//  Copyright (c) 2015 UP Marketplace. All rights reserved.
//

import Foundation

class UPMSellCategoryTVC: UPMSellDetailsTVC, UPMTablePickerVCDelegate {
  
  // MARK: - Constants
  let Category = "Category"
  let Tag = "Tag"
  
  // MARK: - Listing
  var otherListing: UPMOtherListing = UPMOtherListing()
  override var listing: UPMListing? {
    get { return otherListing }
    set { if newValue is UPMOtherListing { otherListing = newValue as! UPMOtherListing } }
  }
  
  // MARK: - Pickers
  
  lazy private var categoryPickerTVC: UPMTablePickerVC = {
    var controller = UPMTablePickerVC()
    controller.datasource = SingleSectionDataSource(rows: UPMCategoryTag.categoryTagManager.categories())
    controller.delegate = self
    return controller
    }()
  
  lazy private var tagPickerTVC: UPMTablePickerVC = {
    var controller = UPMTablePickerVC()
    controller.delegate = self
    return controller
    }()
  
  // MARK: - View
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.estimatedRowHeight = 1000 // auto-layout simulator fix
    navigationItem.title = "Filter Category"
    
  }
  
  // MARK: - Items
  
  override func createRequiredItems() {
    func initItems() {
      self.didSelectItem(self.categoryPickerTVC, item: self.otherListing.category)
      self.didSelectItem(self.tagPickerTVC, item: self.otherListing.tag)
    }
    requiredItems.addItem(UPMSellItem(title: Category, description: "Select"))
    requiredItems.addItem(UPMSellItem(title: Tag, description: "Select"))
    initItems()
  }
  
  // MARK: - TableView
  
  override func didSelectItem(item: UPMSellItem) {
    switch item.title {
    case Category:
      navigationController?.pushViewController(categoryPickerTVC, animated: true)
    case Tag:
      tagPickerTVC.datasource = SingleSectionDataSource(rows: UPMCategoryTag.categoryTagManager.tags()[self.otherListing.category!]!)
      navigationController?.pushViewController(tagPickerTVC, animated: true)
    default: break
    }
  }
  
  override func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String? {
    return tableView.numberOfSections()-1 == section ? "Choosing an appropriate category helps other students to find your listing!" : nil
  }
  
  // Disable tag until category has been chosen
  override func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    if !requiredItems.itemWithTitle(Category)!.isComplete && requiredItems.itemAtIndex(indexPath.row).title == Tag {
      return false
    }
    return true
  }
  
  // MARK: - Delegate

  func didSelectItem(sender: UPMTablePickerVC, item: AnyObject?) {
    if let category = item as? String where sender == categoryPickerTVC {
      otherListing.category = category
      requiredItems.updateItemWithTitle(Category, description: category, isComplete: true)
    } else if let tag = item as? String where sender == tagPickerTVC {
      otherListing.tag = tag
      requiredItems.updateItemWithTitle(Tag, description: tag, isComplete: true)
    }
  }
  
}

