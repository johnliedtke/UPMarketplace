//
//  AppDelegate.swift
//  UPMarketplace
//
//  Created by John Liedtke on 10/9/14.
//  Copyright (c) 2014 UP Marketplace. All rights reserved.
//

import UIKit

extension UIViewController {
  func APP() -> AppDelegate {
    return UIApplication.sharedApplication().delegate as! AppDelegate
  }
  
  func hideHuddieWithMessage(message: String, delay: NSTimeInterval, action: (()->())?) {
    dispatch_async(dispatch_get_main_queue()){ [unowned self] in
      self.delay(delay - 0.1) {
        self.APP().hud.labelText = message
      }
      self.delay(delay) {
        self.APP().hud.hide(true)
        if let act = action {
          act()
        }
      }
    }
  }
}
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  
  var hud = MBProgressHUD()
  
  /**
  Displays a MBProgressHUD with a given status message.
  */
  func huddie(#labelText: String) {
    hud.hide(true)
    
    if let windowForHud = UIApplication.sharedApplication().delegate?.window {
      hud = MBProgressHUD.showHUDAddedTo(windowForHud, animated: true)
      
      hud.dimBackground = true
      hud.minShowTime = 0.2
      hud.labelText = labelText
    }
  }
  
  func huddie() {
    huddie(labelText: "")
  }
  
  var window: UIWindow?
  
  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    // Parse initialization
    Parse.setApplicationId("6ZVQsgQNW5KpO6H5os6JxGOxZAFCEdfLua2T3PAm",
      clientKey: "5bsP9MYcxGGU1bZkKC2ovgySNyLkCk5223irCGG0")

    // Parse subclasses
    UPMTextbookListing.registerSubclass()
    UPMOtherListing.registerSubclass()
    UPMHousingListing.registerSubclass()
    UPMReservation.registerSubclass()
    UPMTextbook.registerSubclass()
    UPMUser.registerSubclass()
    UPMActivity.registerSubclass()
    
    
    //PFCloudExt.sendEmailTo(PFUser.currentUser()!, from: PFUser.currentUser()!, subject: "test", body: "test", notification: false)
    
    // Global apperances
    UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.tabBarUnselectedColor()], forState:.Normal)
    UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.lightPurpleColor()], forState:.Selected)
    UIBarButtonItem.appearance().tintColor = UIColor.lightPurpleColor()
    UINavigationBar.appearance().tintColor = UIColor.lightPurpleColor()
    
    /**
    Tab Bar Navigation
    Create the entire navigation for the application.
    
    - New Listings
    - Buy
    - iWant
    - Sell
    - Account
    */
    var controllers = [UIViewController]()
    
    // Buy
    let BuyStoryboard = UIStoryboard(name: "UPMBuy", bundle: nil)
    var buyNewListingsVC = BuyStoryboard.instantiateInitialViewController() as! UIViewController
    var buyNewListingsItem = buyNewListingsVC.tabBarItem
    buyNewListingsItem.title = "New Listings"
    buyNewListingsItem.image = UIImage(named: "new.png")!.imageWithRenderingMode(.AlwaysOriginal)
    buyNewListingsItem.selectedImage = UIImage(named: "NewSelected.png")!.imageWithRenderingMode(.AlwaysOriginal)
    controllers.append(buyNewListingsVC)
    
    //Buy Workflow
    let BuyWorkflowStoryboard = UIStoryboard(name: "UPMBuyWorkflow", bundle: nil)
    var buyCategoryVC = BuyWorkflowStoryboard.instantiateInitialViewController() as! UINavigationController
    var buyTabBarItem = buyCategoryVC.tabBarItem
    buyTabBarItem.title = "Buy"
    buyTabBarItem.image = UIImage(named: "buy.png")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
    buyTabBarItem.selectedImage = UIImage(named: "buySelected.png")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)

    controllers.append(buyCategoryVC)
    
    // Sell
    let SellStoryboard = UIStoryboard(name: Constants.SellStoryboard.MainStoryboard, bundle: nil)
    var sellVC = SellStoryboard.instantiateInitialViewController() as! UINavigationController
    controllers.append(sellVC)
    var sellTabBarItem = sellVC.tabBarItem
    sellTabBarItem.title = "Sell"
    sellTabBarItem.image = UIImage(named: "sell.png")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
    sellTabBarItem.selectedImage = UIImage(named: "sellSelected.png")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
    
    // test barcode
    var navigationController = UINavigationController()
    
    // Account
    var accountStoryboard = UIStoryboard(name: UPMAccountConstants.accountStoryboardIdentifier, bundle: nil)
    var accountNavigation = accountStoryboard.instantiateInitialViewController() as! UINavigationController
    controllers.append(accountNavigation)
    
    var accountItem = accountNavigation.tabBarItem
    accountItem.title = "Account"
    accountItem.image = UIImage(named: "account.png")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
    accountItem.selectedImage = UIImage(named: "accountSelected.png")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)

    var mainTabBarController = UITabBarController()
    mainTabBarController.viewControllers = controllers
    
    
    // Register user defaults 
    let defaultsDict = NSDictionary(contentsOfFile: NSBundle.mainBundle().pathForResource("Defaults", ofType: "plist")!)!
    NSUserDefaults.standardUserDefaults().registerDefaults(defaultsDict as [NSObject : AnyObject])

    
    window?.rootViewController = mainTabBarController
    
    /**
    Parse Stuff
    */
    
    // defaultACL.setPublicReadAccess(true)
    //        PFACL.setDefaultACL(defaultACL, withAccessForCurrentUser: true)
    
    //UPMListing.registerSubclass()
    //UPMOtherListing.registerSubclass()
    //   [[UIBarButtonItem appearance] setTintColor:[UIColor redColor]];
    
    
      // If you would like all objects to be private by default, remove this line.
//        var defaultACL = PFACL.def
//      defaultACL.setPublicReadAccess(true)
  //    PFACL.setDefaultACL(defaultACL, withAccessForCurrentUser: true)
      
      // Parse Push Notifications
//        var userNotificationTypes: UIUserNotificationType = (UIUserNotificationType.Alert |
//            UIUserNotificationType.Badge |
//            UIUserNotificationType.Sound)
//        var settings: UIUserNotificationSettings = UIUserNotificationSettings(forTypes: userNotificationTypes, categories: nil)
//        
//        application.registerUserNotificationSettings(settings)
//        application.registerForRemoteNotifications()
    
      return true
  }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

