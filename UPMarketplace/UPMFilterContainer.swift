//
//  UPMFilterContainer.swift
//  UPMarketplace
//
//  Created by John Liedtke on 3/29/15.
//  Copyright (c) 2015 UP Marketplace. All rights reserved.
//

import Foundation



class UPMFilterContainer: UPMContainerVC, UPMContainerDelegate {
  
  var filterVC: UIViewController!
  
  @IBOutlet var filterView: UIView!

  
  func setUpViewControllers() -> (containerView: UIView, controllers: [UIViewController]) {
    //let filterVC = UPMCategoryFilterMainTVC()
    return (filterView, [filterVC])
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    delegate = self
  }
  
}
