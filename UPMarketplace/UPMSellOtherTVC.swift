//
//  UPMSellOtherTVC.swift
//  UPMarketplace
//
//  Created by John Liedtke on 11/20/14.
//  Copyright (c) 2014 UP Marketplace. All rights reserved.
//

import UIKit

class UPMSellOtherTVC: UPMSellTVC, UPMSellDetailsTVCDelegate {
  
  
  var otherListng: UPMOtherListing = UPMOtherListing()
  override var listing: UPMListing {
    get {
      return otherListng
    }
    set {
      if newValue is UPMOtherListing {
        otherListng = newValue as UPMOtherListing
      }
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()
  tableView.backgroundColor = UIColor.standardBackgroundColor()
    // Do any additional setup after loading the view.
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  override func pushDetailsVC() {
    var detailsVC = UPMSellOtherDetailsTVC()
    detailsVC.listing = listing
    detailsVC.delegate = self
    navigationController?.pushViewController(detailsVC, animated: true)
  }
  
  func didDetailsUpdate(details: String, isComplete: Bool) {

    if isComplete {
      let detailsItem = requiredItems.itemWithTitle(RequiredItems.Details.rawValue)
      detailsItem?.isComplete = isComplete
      detailsItem?.itemDescription = details
    }

  }
  
  override func post() {
    if requiredItems.isItemsComplete() {
      otherListng.saveInBackgroundWithBlock { (success: Bool, error: NSError!) -> Void in
        if success {
          var alertController = UIAlertController(title: "Success!", message: "Your listing has been posted.", preferredStyle: UIAlertControllerStyle.Alert)
          let okayAction = UIAlertAction(title: "Okay", style: .Default, handler: {
            action in
            self.navigationController?.popToRootViewControllerAnimated(true)
            return
            }
          )
          alertController.addAction(okayAction)
          self.presentViewController(alertController, animated: true, completion: nil)
        }
      }
    }
  }
  
}
