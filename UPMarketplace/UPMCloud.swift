//
//  UPMCloud.swift
//  UPMarketplace
//
//  Created by John Liedtke on 1/24/15.
//  Copyright (c) 2015 UP Marketplace. All rights reserved.
//

import UIKit

struct PFCloudExtConstants {
  static let sendEmailFunction = "sendEmail"
}



class PFCloudExt: PFCloud {
  
  
  class func callFunctionAsync(
    name: NSString,
    withParameters parameters: NSDictionary) -> BFTask {
      
      let p = BFTaskCompletionSource()
      
      self.callFunctionInBackground(name as String, withParameters: parameters as [NSObject : AnyObject]) { (result, error) -> Void in
        if let result: AnyObject = result {
          p.setResult(result)
        } else {
          p.setError(error)
        }
      }
      return p.task
  }

}


