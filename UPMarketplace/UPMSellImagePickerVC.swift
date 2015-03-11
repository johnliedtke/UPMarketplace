//
//  UPMSellImagePickerVC.swift
//  UPMarketplace
//
//  Created by John Liedtke on 11/19/14.
//  Copyright (c) 2014 UP Marketplace. All rights reserved.
//

import UIKit

protocol UPMSellImagePickerDelegate: class {
  func didUpdatePhoto(image: UIImage)
}



/**
  Used to pick a photo from the user's photo library or from the camera device
*/
class UPMSellImagePickerVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  @IBOutlet var imageView: UIImageView!
  @IBOutlet var cameraButton: UIToolbar!
  @IBOutlet var toolBar: UIToolbar!
  
  weak var delegate: UPMSellImagePickerDelegate?
  var image: UIImage? = nil

  // MARK: - Private Properties
  var overlayView: UIView?
  
  lazy private var imagePickerController: UIImagePickerController = {
    var imagePickerController = UIImagePickerController()
    imagePickerController.modalPresentationStyle = UIModalPresentationStyle.CurrentContext
    imagePickerController.delegate = self
    return imagePickerController
  }()
  
  var errorAlertController = UIAlertController(title: "Error", message: "", preferredStyle: UIAlertControllerStyle.Alert)

  lazy var actionSheet: UIAlertController = {
    var actionSheet = UIAlertController(title: "Add Photo", message: "Choose a way to add a photo to your listing.", preferredStyle: .ActionSheet)
    actionSheet.addAction(UIAlertAction(title: "Choose from Photo Library", style: .Default, handler: {
      (action) in
      self.showImagePickerForSourceType(.PhotoLibrary)
    }))
    if UIImagePickerController.isSourceTypeAvailable(.Camera) {
      actionSheet.addAction(UIAlertAction(title: "Take new Photo", style: .Default, handler: { (action) -> Void in
        self.showImagePickerForSourceType(UIImagePickerControllerSourceType.Camera)
      }))
    }
    actionSheet.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler:nil))
    return actionSheet
  }()
  
  // MARK: - Public View Methods
  
  override func viewDidLoad() {
    super.viewDidLoad()
      
    addCancelButtontToNavigationItemWithSelector("didPressCancelButton:")
    addDoneButtonToNavigationItemWithSelector("didPressDoneButton:")
    errorAlertController.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: nil))
    imageView.image = image
    
    // Show actionSheet
    navigationController?.presentViewController(actionSheet, animated: true, completion: nil)
    
    // Hide camera button if no camera
    if !UIImagePickerController.isSourceTypeAvailable(.Camera) {
        toolBar.items?.removeAtIndex(2)
    }
  }
  
  // MARK: - Button Actions
  func didPressCancelButton(sender: AnyObject) -> Void {
    navigationController?.popViewControllerAnimated(true)
  }
  
  func didPressDoneButton(send: AnyObject) -> Void {
    didFinishPickingPhoto()
  }
  
  func didFinishPickingPhoto() {
    if image == nil {
      errorAlertController.message = "Please add or take a pictore."
      presentViewController(errorAlertController, animated: true, completion: nil)
      return
    }
    delegate?.didUpdatePhoto(image!)
    navigationController?.popViewControllerAnimated(true)
  }
  
  
  @IBAction func showImagePickerForCamera(sender: AnyObject) {
    showImagePickerForSourceType(UIImagePickerControllerSourceType.Camera)
  }

  @IBAction func showImagePickerForPhotoPicker(sender: AnyObject) {
    showImagePickerForSourceType(UIImagePickerControllerSourceType.PhotoLibrary)
  }
  
  // MARK: - Image Handling
  
  func showImagePickerForSourceType(sourceType: UIImagePickerControllerSourceType) {


    imagePickerController.sourceType = sourceType
    
    if sourceType == UIImagePickerControllerSourceType.Camera {
      imagePickerController.showsCameraControls = true
    }
    presentViewController(imagePickerController, animated: true, completion: nil)

  }
  
  private func finishAndUpdate() {
    dismissViewControllerAnimated(true, completion: nil)

    imageView.image = image
//    self.imagePickerController = nil
  }
  
  func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
    let image: UIImage = info[UIImagePickerControllerOriginalImage] as! UIImage
    self.image = image
    finishAndUpdate()
  }
}
