//
//  UPMSellExtension.swift
//  UPMarketplace
//
//  Created by John Liedtke on 11/9/14.
//  Copyright (c) 2014 UP Marketplace. All rights reserved.
//



let SellDescriptionStoryboard = "SellDescription"
let SellPriceFormatStoryboard = "SellPriceFormat"
let SellTitleStoryboard = "SellTitle"
let SellStoryboard = "UPMSell"
let SellImagePickerStoryboard = "SellImagePicker"

/**
  Abstracts part of the UPMSellTVC. This extension handles pushing the default 
  view controllers for collection user-input.
*/
extension UPMSellTVC {
  
  func pushDescriptionVC() {
    let storyboard = UIStoryboard(name: SellStoryboard, bundle: nil)

    var sellDescriptionVC = storyboard.instantiateViewControllerWithIdentifier(SellDescriptionStoryboard) as UPMSellDescriptionVC
    sellDescriptionVC.delegate = self
    if let desc = listing?.descriptionS {
      sellDescriptionVC.descriptionS = (desc)
    }
    navigationController?.pushViewController(sellDescriptionVC, animated: true)
  }
  
  func pushPriceFormatVC() {
    let storyboard = UIStoryboard(name: SellStoryboard, bundle: nil)
    var priceFormatVC = storyboard.instantiateViewControllerWithIdentifier(SellPriceFormatStoryboard) as UPMSellPriceFormatTVC
    priceFormatVC.delegate = self
    
    if let price = listing?.price {
      if let limit = listing?.limit {
        if let oBO = listing?.oBO {
          priceFormatVC.price = price
          priceFormatVC.limit = limit
          priceFormatVC.oBO = Bool(oBO)
        }
      }
    }
    navigationController?.pushViewController(priceFormatVC, animated: true)
  }
  
  func pushTitleVC() {
    let storyboard = UIStoryboard(name: SellStoryboard, bundle: nil)
    var titleVC = storyboard.instantiateViewControllerWithIdentifier(SellTitleStoryboard) as UPMSellTitleTVC
    titleVC.delegate = self
    if let title = listing?.title {
      titleVC.titleS = title
    }
    navigationController?.pushViewController(titleVC, animated: true)
  }
  
  func pushImagePickerVC() {
    let Storyboard = UIStoryboard(name: SellStoryboard, bundle: nil)
    if let imagePickerVC = Storyboard.instantiateViewControllerWithIdentifier(SellImagePickerStoryboard) as? UPMSellImagePickerVC {
    imagePickerVC.delegate = self
    if let image = listing?.photo {
      imagePickerVC.image = image
    }
    imagePickerVC.hidesBottomBarWhenPushed = true
    navigationController?.pushViewController(imagePickerVC, animated: true)
    }
  }
  
  func pushDetailsVC() {

  }
  
}