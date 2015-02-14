//
//  UPMConstants.swift
//  UPMarketplace
//
//  Created by John Liedtke on 12/21/14.
//  Copyright (c) 2014 UP Marketplace. All rights reserved.
//

import UIKit

struct Constants {
  struct SellStoryboard {
  static let MainStoryboard = "SellMain"
  }
}

extension PFObject {
  
  class func isDataAvailableforObjects(objects: [PFObject]?) -> Bool {
    if let objs = objects {
      for o in objs {
        if !o.isDataAvailable() {
          return false
        }
      }
      return true
  } else {
      return false
  }
  }
}
// adopted from http://code.tutsplus.com/tutorials/ios-sdk-detecting-network-changes-with-reachability--mobile-18299

class UPMReachabilityManager {

  static let reachabilityManager = Reachability(hostName: "www.google.com")
  
  
  class func alertOfNoNetworkConnectionInController(controller: UIViewController) {
    var alertController = UIAlertController(title: "No Network Connection", message: "The action cannot be completed because you have no network connection.", preferredStyle: .Alert)
    alertController.addAction(UIAlertAction(title: "Okay", style: .Default, handler: nil))
    controller.presentViewController(alertController, animated: true, completion: nil)
  }

  // MARK: Class methods
  class func isReachable() -> Bool {
    return reachabilityManager.isReachable()
  }

  class func isUnreachable() -> Bool {
    return !reachabilityManager.isReachable()
  }

  class func isReachableViaWWAN() -> Bool {
    return reachabilityManager.isReachableViaWWAN()
  }

  class func isReachableViaWifi() -> Bool {
    return reachabilityManager.isReachableViaWiFi()
  }
  
}

