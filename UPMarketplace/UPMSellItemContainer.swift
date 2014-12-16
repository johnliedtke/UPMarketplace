//
//  UPMSellItemContainer.swift
//  UPMarketplace
//
//  Created by John Liedtke on 11/9/14.
//  Copyright (c) 2014 UP Marketplace. All rights reserved.
//

import UIKit

class UPMSellItemContainer {
  
  var items = [UPMSellItem]()
  var count: Int {
    get {
      return items.count
    }
  }
  
  convenience init(items: [UPMSellItem]) {
    self.init()
    self.items += items
  }
  
  func addItem(item: UPMSellItem) {
    items.append(item)
  }
  
  func addItems(items: [UPMSellItem]) {
    self.items += items
  }
  
  func itemAtIndex(index: Int) -> UPMSellItem {
    if index > items.count {
      return items[0]
    }
    return items[index]
  }
  
  func itemWithTitle(title: String) -> UPMSellItem? {
    for i in items {
      if i.title == title {
        return i
      }
    }
    return nil
  }
  
  /// Updates the an item given with a given title. Does nothing if item 
  /// does not exist.
  ///
  /// :param: title Title of item to be updated
  /// :param: description New description for item
  /// :param: isComplete New isComplete status
  func updateItemWithTitle(title: String, description: String, isComplete: Bool) {
    var item = itemWithTitle(title)
    if item == nil {
      return;
    } else {
      item?.itemDescription = description
      item?.isComplete = isComplete
    }
  }
  
  func removeItemWithTitle(title: String) {
    for i in 0..<count {
      if itemAtIndex(i).title == title {
        items.removeAtIndex(i)
        break
      }
    }
  }
  
  func isItemsComplete() -> Bool {
    for i in items {
      if !i.isComplete {
        return false
      }
    }
    return true
  }
  
  func description() -> String {
    var d = ""
    for item in items {
      d += "\(item.title): \(item.itemDescription)\n"
    }
    return d == "" ? "Select" : d.substringToIndex(advance(d.startIndex, countElements(d)-1))
  }

}
