//
//  UPMReachabilityManager.swift
//  UPMarketplace
//
//  Created by John Liedtke on 2/14/15.
//  Copyright (c) 2015 UP Marketplace. All rights reserved.
//

// adopted from http://code.tutsplus.com/tutorials/ios-sdk-detecting-network-changes-with-reachability--mobile-18299

class UPMReachabilityManager {
  
  let reachabilityManager = Reachability(hostName: "www.parse.com")
  
  class func alertOfNoNetworkConnectionInController(controller: UIViewController) {
    var alertController = UIAlertController(title: "No Network Connection", message: "The action cannot be completed because you have no network connection.", preferredStyle: .Alert)
    alertController.addAction(UIAlertAction(title: "Okay", style: .Default, handler: nil))
    controller.presentViewController(alertController, animated: true, completion: nil)
  }
  
  // MARK: Class methods
  class func isReachable() -> Bool {
    let rm = Reachability(hostName: "www.parse.com")
    return rm.isReachable()
  }
  
  class func isUnreachable() -> Bool {
    let rm = Reachability(hostName: "www.parse.com")
    return !rm.isReachable()
  }
  
  class func isReachableViaWWAN() -> Bool {
    let rm = Reachability(hostName: "www.parse.com")
    return rm.isReachableViaWWAN()
  }
  
  class func isReachableViaWifi() -> Bool {
    let rm = Reachability(hostName: "www.parse.com")
    return rm.isReachableViaWiFi()
  }
  
}

class UPMCategoryTag {
  //let categoryTagManager = UPMCategoryTag()
  
  class func categoryTagManager() -> UPMCategoryTag {
    return UPMCategoryTag()
  }
  
  func tags() -> [String: [String]] {
    return [
      "Furniture": ["Desk", "Table", "Chair", "Light", "Sofa", "Bed", "Bed Frame", "Storage"],
      "Appliance": ["Mini Fridge", "Microwave", "Coffee Machine", "Toaters", "Large Appliances", "Vaccum", "Mixing Supplies", "Freezer", "Iron", "Small Appliance"],
      "Transportation": ["Bike", "Skateboard", "Scooter", "Car", "Other", "Locks"],
      "Clothing": ["Mens", "Womens"],
      "Decor": ["Posters", "Mirrors", "Pictures", "Holiday Decor", "Other"],
      "Cooking": ["Pots and Pans", "Dishes", "Rice Cookers", "Utensiles"],
      "School": ["Writing Implements", "Binders", "Paper", "Notebooks", "Backpacks", "Calculators", "Nursing Supplies"],
      "Outdoors": ["Furniture", "BBQ", "Sporting Goods", "Other"],
      "Electronics": ["Computers", "Phones", "Phone Cases", "Printers", "Computer Accessories", "Speakers", "TV", "Gaming Systems", "Games", "Cables", "Cameras", "Internet Supplies", "Camera"]
    ]
  }
 
  
  func categories() -> [String] {
    return ["Furniture",	"Appliance",	"Transportation",	"Clothing", "Decor",	"Cooking", "School",	"Outdoors", "Electronics"].sorted(<)
  }
  


  
}