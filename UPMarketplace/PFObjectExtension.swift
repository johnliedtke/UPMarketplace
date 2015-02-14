//
//  PFObjectExtension.swift
//  UPMarketplace
//
//  Created by John Liedtke on 2/14/15.
//  Copyright (c) 2015 UP Marketplace. All rights reserved.
//


extension PFObject {
  
  class func isDataAvailableforObjects(objects: [PFObject]?) -> Bool {
    if let objs = objects {
      for o in objs {
        if !o.isDataAvailable() {
          return false
        }
      }
      return true
    } else {
      return false
    }
  }
  
  func fetchAsync(object: PFObject) -> BFTask {
    var task = BFTaskCompletionSource()
    object.fetchInBackgroundWithBlock {
      (object: PFObject!, error: NSError!) -> Void in
      if error == nil {
        task.setResult(object)
      } else {
        task.setError(error)
      }
    }
    return task.task
  }
  
  class func fetchAllInBackgroundBolt(objects: [PFObject]) -> BFTask {
    var task = BFTaskCompletionSource()
    PFObject.fetchAllInBackground(objects) { (objects: [AnyObject]!, error: NSError!) -> Void in
      if error == nil {
        task.setResult(objects)
      } else {
        task.setError(error)
      }
    }
    return task.task
  }

}




