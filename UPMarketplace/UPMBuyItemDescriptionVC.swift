//
//  UPMBuyItemDescriptionVC.swift
//  UPMarketplace
//
//  Created by Krismy on 1/31/15.
//  Copyright (c) 2015 UP Marketplace. All rights reserved.
//

import UIKit

class UPMBuyItemDescriptionVC: UIViewController {
  
  
  var descriptionS: String = ""
  
  lazy var descTextView: UITextView = {
    var textView = UITextView()
    textView.setTranslatesAutoresizingMaskIntoConstraints(false)
    textView.font = UIFont.standardTextFont()
    textView.userInteractionEnabled = false
    textView.backgroundColor = UIColor.clearColor()
    textView.contentInset = UIEdgeInsetsMake(-4,-8,0,0);
    textView.clipsToBounds = false

    return textView
  }()
  
  convenience init(desc: String) {
    self.init()
    self.descriptionS = desc
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = UIColor.standardBackgroundColor()
    self.automaticallyAdjustsScrollViewInsets = false
    navigationItem.title = "Description"
    view.clipsToBounds = false
    view.addSubview(descTextView)
    descTextView.text = descriptionS
    
    var elements = NSDictionary(dictionary: ["descTextView": descTextView,  "topLayoutGuide": topLayoutGuide])
    
    view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-(hlp)-[descTextView]-(hrp)-|", options: NSLayoutFormatOptions.DirectionLeadingToTrailing, metrics: UPMStandards.autoLayoutMetrics, views: elements))
    view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[topLayoutGuide]-[descTextView]|", options: NSLayoutFormatOptions.DirectionLeadingToTrailing, metrics: nil, views: elements))
    
    descTextView.layoutIfNeeded()
  }

  override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
      // Dispose of any resources that can be recreated.
  }
  

}
