//
//  UPMContainerVC.swift
//  UPMarketplace
//
//  Created by John Liedtke on 1/28/15.
//  Copyright (c) 2015 UP Marketplace. All rights reserved.
//

import UIKit

/**
A view controller with extended functionality for easily managing
child view controllers.
*/
public class UPMContainerVC: UIViewController {
  
  // MARK: - Public Properties
  
  /// Where you want to display the child controller's view
  var containerView: UIView!
  
  /// Enable left and right transitions
  var isLeftRightTransition = true
  
  /// Duration of changing container controllers
  var transitionDuration = 0.45
  
  /// Visible view controller in containerView
  private(set) public var currentViewController: UIViewController!
  
  // MARK: - Private Properties
  
  /// Holds co
  private var containerViewControllers = [UIViewController]()
  
  /// Is the controller in a state of changing child controllers
  private var isTransitioning = false
  
  // MARK: - Public Methods
  
  /**
  MUST OVERRIDE
  Initialize all container controllers and return them along with the view to be used
  for the container view. Method gets called in viewDidLoad() once.
  - Do not call this method on your own.
  - Other customization may be done here, e.g. adjusting transitionDuration
  
  :returns: containerView View to display view controllers
  :returns: controllers View controllers to display in containerView
  */
  public func setUpViewControllers() -> (containerView: UIView, controllers: [UIViewController]) {
    
    return (UIView(), [UIViewController]())
  }
  
  override public func viewDidLoad() {
    super.viewDidLoad()
    // Load child view controllers
    containerView = setUpViewControllers().containerView
    containerViewControllers = setUpViewControllers().controllers
    
    // Add initial controller
    currentViewController = containerControllerAtIndex(0)
    addChildViewController(currentViewController)
    containerView.addSubview(currentViewController.view)
    currentViewController.didMoveToParentViewController(self)
    
  }
  
  /**
  Transitions to the next view controller in a "circular way".
  */
  public func nextViewController() {
    let currentIndex = currentControllerIndex()
    
    if currentIndex+1 >= containerViewControllers.count {
      transitionToViewControllerAtIndex(0)
    } else {
      transitionToViewControllerAtIndex(currentIndex+1)
    }
  }
  
  /**
  Returns the index of the visible view controller.
  
  :returns: index of current view controller
  */
  public func currentControllerIndex() -> Int {
    for (index, vc) in enumerate(containerViewControllers) {
      if vc.isEqual(currentViewController) {
        return index
      }
    }
    return 0
  }
  
  /**
  Change the view of the containerView to display the view of the controlle at
  the index of containerViewControllers.
  
  :param: index Index of view controller to display
  */
  public func transitionToViewControllerAtIndex(index: Int) {
    
    var nextViewController: UIViewController! = (containerControllerAtIndex(index))
    
    if nextViewController == nil || isTransitioning {
      return
    }
    isTransitioning = true
    
    addChildViewController(nextViewController)
    currentViewController.willMoveToParentViewController(nil)
    
    // Throw the nextViewController to the left/right for transition
    let height = CGRectGetHeight(containerView.frame)
    let width = CGRectGetHeight(containerView.frame)
    
    if isLeftRightTransition {
      var currentIndex = currentControllerIndex()
      if currentIndex > index && index - 1 != containerViewControllers.count {
        nextViewController.view.frame = CGRectMake(-width, 0, width, height)
      } else {
        nextViewController.view.frame = CGRectMake(width, 0, width, height)
      }
    }
    
    transitionFromViewController(currentViewController, toViewController: nextViewController, duration: transitionDuration, options: nil, animations: { () -> Void in
      
      self.currentViewController.view.frame = CGRectMake(0-width, 0, width, height)
      nextViewController.view.frame = CGRectMake(0, 0, width, height)
      
      }) { (finished) -> Void in
        
        self.currentViewController.removeFromParentViewController()
        nextViewController.didMoveToParentViewController(self)
        self.currentViewController = nextViewController
        self.isTransitioning = false
    }
  }
  
  // MARK: - Private Methods
  
  private func containerControllerAtIndex(index: Int) -> UIViewController? {
    if index < 0 && index > containerViewControllers.count {
      return nil
    }
    return containerViewControllers[index]
    
  }
}

