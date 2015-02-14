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
      accountActivityTVC.view.frame = CGRectMake(0, 0, accountView.bounds.width, accountView.bounds.height)
    
    
    var accountReservedTVC = UPMAccountReservedTVC(style: .Plain, className: "UPMOtherListing")
    
  
    isLeftRightTransition = false
    
    
    
    return (accountView, [accountActivityTVC, accountReservedTVC])
  }
  
  @IBAction func segmentedControlDidChange(sender: AnyObject) {
    transitionToViewControllerAtIndex(segmentedControl.selectedSegmentIndex)
    
    
  }
    override func viewDidLoad() {
      super.viewDidLoad()
      delegate = self

        // Do any additional setup after loading the view.
    }
  
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
