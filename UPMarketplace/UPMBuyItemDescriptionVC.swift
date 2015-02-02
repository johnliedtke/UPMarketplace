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
  
  @IBOutlet var descriptiontextView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
      descriptiontextView.text = descriptionS

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
