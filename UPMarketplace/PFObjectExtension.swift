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

extension PFQuery {
  /**
  Performs all queries in parallel and combines the result into an array.
  
  :returns: BFTask with [PFObject] as result
  */
  class func combineQueriesInBackground(queries: [PFQuery]) -> BFTask {
    var objectsTask = BFTaskCompletionSource()
    
    let tasks = queries.map { $0.findObjectsInBackground() }

    var result = [UPMListing]()
    
    BFTask(forCompletionOfAllTasks: tasks).continueWithBlock {
      (task) in
      for t in tasks {
        if let res = t.result as? [UPMListing] {
          result += res
        } else {
          objectsTask.setResult(t.error)
        }
      }
      return BFTask(forCompletionOfAllTasks: tasks)
    }.continueWithExecutor(BFExecutor.mainThreadExecutor(), withSuccessBlock: { (task) -> AnyObject! in
      objectsTask.setResult(result)
      return nil
      
    })
    return objectsTask.task
  }
}

extension PFUser {
  
  /**
  Checks if the user has a verfified email.
  
  :return: Email verified
  */
  func isEmailVerified() -> Bool {
    //self["emailVerified"].fetchIfNeeded()
    return self["emailVerified"] as! Bool
  }
  
  /**
  A task for loggin in a user given a username and password in the
  background.
  
  :param: username User's Username (email)
  :param: password User's password
  */
  class func loginAsync(username: String, password: String) -> BFTask {
    let task = BFTaskCompletionSource()
    
    PFUser.logInWithUsernameInBackground(username, password: password) {
      (user, error) -> Void in
      if error == nil {
        task.setResult(user)
      } else {
        task.setError(error)
      }
    }
    return task.task
  }

}










