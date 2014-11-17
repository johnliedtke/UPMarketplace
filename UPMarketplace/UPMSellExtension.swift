//
//  UPMSellExtension.swift
//  UPMarketplace
//
//  Created by John Liedtke on 11/9/14.
//  Copyright (c) 2014 UP Marketplace. All rights reserved.
//

import Foundation

let SellDescriptionStoryboard = "SellDescription"
let SellPriceFormatStoryboard = "SellPriceFormat"
let SellTitleStoryboard = "SellTitle"
let SellStoryboard = "UPMSell"

extension UPMSellTVC {
  
  func pushDescriptionVC() {
    let storyboard = UIStoryboard(name: SellStoryboard, bundle: nil)

    var sellDescriptionVC = storyboard.instantiateViewControllerWithIdentifier(SellDescriptionStoryboard) as UPMSellDescriptionVC
    sellDescriptionVC.delegate = self
    sellDescriptionVC.descriptionS = (listing?.descriptionS)!
    navigationController?.pushViewController(sellDescriptionVC, animated: true)
  }
  
  func pushPriceFormatVC() {
    let storyboard = UIStoryboard(name: SellStoryboard, bundle: nil)
    var priceFormatVC = storyboard.instantiateViewControllerWithIdentifier(SellPriceFormatStoryboard) as UPMSellPriceFormatTVC
    priceFormatVC.delegate = self
    priceFormatVC.price = (listing?.price)!
    priceFormatVC.limit = (listing?.limit)!
    priceFormatVC.oBO = (listing?.oBO)!

    navigationController?.pushViewController(priceFormatVC, animated: true)
  }
  
  func pushTitleVC() {
    let storyboard = UIStoryboard(name: SellStoryboard, bundle: nil)
    var titleVC = storyboard.instantiateViewControllerWithIdentifier(SellTitleStoryboard) as UPMSellTitleTVC
    titleVC.delegate = self
    navigationController?.pushViewController(titleVC, animated: true)
    

  }
  
}