//
//  DefaultVC.swift
//  UPMarketplace
//
//  Created by John Liedtke on 11/8/14.
//  Copyright (c) 2014 UP Marketplace. All rights reserved.
//

import UIKit

class DefaultVC: UIViewController {
  let MainSellStoryboardIdentifier = "UPMSell"
  let SellStoryboardIdentifier = "SellStoryboard"
  @IBAction func buttonPushed(sender: AnyObject) {
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:nil];
//    MyNewViewController *myVC = (MyNewViewController *)[storyboard instantiateViewControllerWithIdentifier:@"myViewCont"];
    
    let SellStoryboard = UIStoryboard(name: MainSellStoryboardIdentifier, bundle: nil)
    var sellTVC = SellStoryboard.instantiateViewControllerWithIdentifier(SellStoryboardIdentifier) as! UPMSellTVC
      navigationController?.pushViewController(sellTVC, animated: true)
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
