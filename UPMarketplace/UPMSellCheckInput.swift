//
//  UPMSellCheckInputProtocol.swift
//  UPMarketplace
//
//  Created by John Liedtke on 12/18/14.
//  Copyright (c) 2014 UP Marketplace. All rights reserved.
//




/// Protocol to ensure user-input is validated
protocol UPMSellCheckInput {
  
  var alertController: UIAlertController {get set}
  
  /// Validate the user-input
  ///
  /// :returns: Empty string or description of errors
  func validateInput() -> String
  
  /// Should call validateInput() and show alert view notifying
  /// user ong problems 
  ///
  /// :returns: Boolean indicating error
  func alertIfInputError() -> Bool
  
  /// Add action items/buttons to alertController. Should call in 
  /// viewDidLoad()
  //func addActionItemsToAlertController() -> Void
}