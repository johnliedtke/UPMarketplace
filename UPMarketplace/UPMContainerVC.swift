//
//  ViewController.swift
//  ContainerViews
//
//  Created by John Liedtke on 1/27/15.
//  Copyright (c) 2015 John Liedtke. All rights reserved.
//

import UIKit


/**
  Subclasses of UPMContainerVC should adhere to this protocol.
*/
public protocol UPMContainerDelegate {
  /**
  Initialize all container controllers and return them along with the view to be used
  for the container view. Method gets called in viewDidLoad() of UPMContainerVC.
  - Do not call this method on your own.
  - Other customization may be done here, e.g. adjusting transitionDuration
  
  :returns: containerView View to display view controllers
  :returns: controllers View controllers to display in containerView
  */
  func setUpViewControllers() -> (containerView: UIView, controllers: [UIViewController])
}


/**
A view controller with extended functionality for easily managing
child view controllers.
*/
public class UPMContainerVC: UIViewController {
  
  // MARK: - Public Properties
  
  /// Where you want to display the child controller's view
  
  /// Delegate
  var delegate: UPMContainerDelegate! {
    didSet {
      addInitialController()
    }
  }
  
  /// Enable left and right transitions
  var isLeftRightTransition = true
  
  /// Duration of changing container controllers
  var transitionDuration = 0.45
  
  /// Visible view controller in containerView
  private(set) public var currentViewController: UIViewController!
  
  // MARK: - Private Properties
  
  /// Holds co
  lazy private var containerViewControllers: [UIViewController] = {
    var controllers = self.delegate.setUpViewControllers().controllers
    return controllers
    }()
  
  lazy private var containerView: UIView = {
    var view = self.delegate.setUpViewControllers().containerView
    return view
    }()
  
  
  /// Is the controller in a state of changing child controllers
  private var isTransitioning = false
  
  // MARK: - Public Methods
  
  override public func viewDidLoad() {
    super.viewDidLoad()
    
  }
  
  public override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
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
    
    if isTransitioning || currentControllerIndex() == index {
      return
    }
    isTransitioning = true
    var nextViewController: UIViewController! = (containerControllerAtIndex(index))

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
    
    
    //nextViewController.view.alpha = 0.5
    transitionFromViewController(currentViewController, toViewController: nextViewController, duration: transitionDuration, options: nil, animations: { () -> Void in
      
      
      var nextView = nextViewController.view
      nextView.alpha = 1.0
      nextView.setTranslatesAutoresizingMaskIntoConstraints(false)

      
      var elementsDict = NSDictionary(dictionary: ["nextView": nextView])
      self.containerView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
        "H:|[nextView]|",
        options: NSLayoutFormatOptions.DirectionLeftToRight,
        metrics: nil,
        views: elementsDict as! [NSObject : AnyObject]))
      
      self.containerView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
        "V:|[nextView]|",
        options: NSLayoutFormatOptions.DirectionLeftToRight,
        metrics: nil,
        views: elementsDict as! [NSObject : AnyObject]))
      
      
      if self.isLeftRightTransition {
        self.currentViewController.view.frame = CGRectMake(0-width, 0, width, height)
        nextViewController.view.frame = CGRectMake(0, 0, width, height)
      }


      }) { (finished) -> Void in
        nextViewController.didMoveToParentViewController(self)
        self.currentViewController.removeFromParentViewController()
        self.currentViewController = nextViewController
        self.isTransitioning = false
    }
  }
  
  
  
  // MARK: - Private Methods
  
  private func addInitialController() {
    
    currentViewController = containerControllerAtIndex(0)
    addChildViewController(currentViewController)
    containerView.addSubview(currentViewController.view)
    currentViewController.didMoveToParentViewController(self)
    
    
    var acv = currentViewController.view
    currentViewController.view.setTranslatesAutoresizingMaskIntoConstraints(false)
    var elementsDict = NSDictionary(dictionary: ["acv": acv])
    
    
    containerView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
      "H:|[acv]|",
      options: NSLayoutFormatOptions.DirectionLeftToRight,
      metrics: nil,
      views: elementsDict as! [NSObject : AnyObject]))
    
    containerView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
      "V:|[acv]|",
      options: NSLayoutFormatOptions.DirectionLeftToRight,
      metrics: nil,
      views: elementsDict as! [NSObject : AnyObject]))
    
  }
  
  private func containerControllerAtIndex(index: Int) -> UIViewController? {
    if index < 0 && index > containerViewControllers.count {
      return nil
    }
    return containerViewControllers[index]
    
  }
}

