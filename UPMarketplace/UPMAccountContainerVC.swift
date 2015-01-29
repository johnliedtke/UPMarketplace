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

class UPMAccountContainerVC: UPMContainerVC {
  
  // MARK: - Public Properties
  
  @IBOutlet var segmentedControl: UISegmentedControl!
  
  @IBOutlet var accountView: UIView!
  
  // MARK: - Private Properties 

  // MARK: - Public Methods
  
  override func setUpViewControllers() -> (containerView: UIView, controllers: [UIViewController]) {
    var accountActivityTVC = UPMAccountActivityTVC()
    return (accountView, [accountActivityTVC])
  }
  
  @IBAction func segmentedControlDidChange(sender: AnyObject) {
    
  }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
