//
//  UPMSellItemContainer.swift
//  UPMarketplace
//
//  Created by John Liedtke on 11/9/14.
//  Copyright (c) 2014 UP Marketplace. All rights reserved.
//

import UIKit

/**
  Container class for UPMSellItems.
*/
class UPMSellItemContainer {
  
  // MARK: Public Properties
  
  /// The number of items in the container.
   var count: Int {
    get { return items.count }
  }
  
  var completedCount: Int {
    get { return items.filter({ $0.isComplete }).count } }
  
  // MARK: - Private Properties
  
  /// Used to store the
  private var items = [UPMSellItem]()
  
  convenience init(items: [UPMSellItem]) {
    self.init()
    self.items += items
  }
  
  /// Adds a UPMSellItem.
  func addItem(item: UPMSellItem) {
    items.append(item)
  }
  
  /// Add UPMSellItems from an array.
  func addItems(items: [UPMSellItem]) {
    self.items += items
  }
  
  /// Retrieve item by index position, returns first item if
  /// invalid index.
  func itemAtIndex(index: Int) -> UPMSellItem {
    if index > items.count {
      return items[0]
    }
    return items[index]
  }
  
  /// Retrieve item by title.
  func itemWithTitle(title: String) -> UPMSellItem? {
    for i in items {
      if i.title == title {
        return i
      }
    }
    return nil
  }
  
  /**
  Updates the an item given with a given title. Does nothing if item
  does not exist.
  
  :param: title Title of item to be updated
  :param: description New description for item
  :param: isComplete New isComplete status
  */
  func updateItemWithTitle(title: String, description: String, isComplete: Bool) {
    var item = itemWithTitle(title)
    if item == nil {
      return;
    } else {
      item?.itemDescription = description
      item?.isComplete = isComplete
    }
  }
  
  /// Remove item by title, does nothing if no item has the title.
  func removeItemWithTitle(title: String) {
    for i in 0..<count {
      if itemAtIndex(i).title == title {
        items.removeAtIndex(i)
        break
      }
    }
  }
  
  /**
  Check if all items in container are marked complete.
  
  :returns: True if all items are complete.
  */
  func isItemsComplete() -> Bool {
    for i in items {
      if !i.isComplete {
        return false
      }
    }
    return true
  }
  
  /// Creates a description of all items in container.
  func description() -> String {
    var d = ""
    for item in items {
      if item.isComplete {
        d += "\(item.title): \(item.itemDescription)\n"
      } else {
        d += "\(item.title): Missing\n"
      }
    }
    return d == "" ? "Select" : d.substringToIndex(d.endIndex.predecessor())
  }
  
  /// Creates a description of missing items 
  func missingDescription() -> String {
    var d = ""
    for item in items {
      if item.isComplete == false {
        d += "\(item.title): Missing\n"
      }
    }
    return d.substringToIndex(d.endIndex.predecessor())
  }


}
