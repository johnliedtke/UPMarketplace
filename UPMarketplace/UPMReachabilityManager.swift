//
//  UPMReachabilityManager.swift
//  UPMarketplace
//
//  Created by John Liedtke on 2/14/15.
//  Copyright (c) 2015 UP Marketplace. All rights reserved.
//

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