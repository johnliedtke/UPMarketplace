//
//  UPMViewControllerExtension.swift
//  UPMarketplace
//
//  Created by John Liedtke on 11/9/14.
//  Copyright (c) 2014 UP Marketplace. All rights reserved.
//

import Foundation

extension UIViewController {
  
  func addCancelButtontToNavigationItemWithSelector(selector: String) {
    var cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Plain, target: self, action: NSSelectorFromString(selector))
    navigationItem.setLeftBarButtonItem(cancelButton, animated: true)

  }
  
  func addDoneButtonToNavigationItemWithSelector(selector: String) {
    var doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Done, target: self, action: NSSelectorFromString(selector))
    navigationItem.setRightBarButtonItem(doneButton, animated: true)
  }
  
  func getNavigationBarHeight() -> CGFloat {
    if let height = self.navigationController?.navigationBar.frame.height {
      return height
    } else {
      return 0
    }
  }
  
  
}

extension String {
  subscript (i: Int) -> String {
    return String(Array(self)[i])
  }
}

extension Double {
  func toString() -> String {
    return String(format: "%.2f",self)
  }
}
