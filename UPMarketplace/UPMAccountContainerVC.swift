//
//  UPMAccountContainerVC.swift
//  UPMarketplace
//
//  Created by John Liedtke on 1/28/15.
//  Copyright (c) 2015 UP Marketplace. All rights reserved.
//

import UIKit

struct UPMAccountConstants {
  static let accountStoryboardIdentifier = "UPMAccount"
  
}

class UPMAccountContainerVC: UPMContainerVC, UPMContainerDelegate {
  
  // MARK: - Public Properties
  
  @IBOutlet var segmentedControl: UISegmentedControl!
  
  @IBOutlet var accountView: UIView!
  
  // MARK: - Private Properties 
  
  // MARK: - Public Methods
  
  func setUpViewControllers() -> (containerView: UIView, controllers: [UIViewController]) {
    var accountActivityTVC = UPMAccountActivityTVC(style: .Plain, className: "UPMOtherListing")
    accountActivityTVC.sectionKey = "title"
    var accountReservedTVC = UPMAccountReservedTVC(style: .Plain, className: "UPMOtherListing")
    accountReservedTVC.sectionKey = "status"
    var sellingTVC = UPMAccountSellingTVC()
    
    isLeftRightTransition = false
    
    return (accountView, [accountActivityTVC, accountReservedTVC, sellingTVC])
  }
  
  @IBAction func segmentedControlDidChange(sender: AnyObject) {
    transitionToViewControllerAtIndex(segmentedControl.selectedSegmentIndex)
    
    
  }
  
  // MARK: - View
  
  override func viewDidLoad() {
    super.viewDidLoad()
    delegate = self
    navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Settings", style: .Plain, target: self, action: "didPushSettings")
  }
  
  func didPushSettings() {
    let settingsTVC = UPMAccountSettings()
    navigationController?.pushViewController(settingsTVC, animated: true)
  }
  

}
