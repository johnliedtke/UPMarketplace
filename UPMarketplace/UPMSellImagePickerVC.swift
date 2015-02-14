//
//  UPMSellImagePickerVC.swift
//  UPMarketplace
//
//  Created by John Liedtke on 11/19/14.
//  Copyright (c) 2014 UP Marketplace. All rights reserved.
//

import UIKit

protocol UPMSellImagePickerDelegate {
  func didUpdatePhoto(image: UIImage)
}


class UPMSellImagePickerVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  @IBOutlet var imageView: UIImageView!
  @IBOutlet var cameraButton: UIToolbar!
  @IBOutlet var toolBar: UIToolbar!
  
  var delegate: UPMSellImagePickerDelegate?
  var image: UIImage? = nil
   

  var overlayView: UIView?
  var imagePickerController: UIImagePickerController?
  var errorAlertController = UIAlertController(title: "Error", message: "", preferredStyle: UIAlertControllerStyle.Alert)

  override func viewDidLoad() {
    super.viewDidLoad()
      
    addCancelButtontToNavigationItemWithSelector("didPressCancelButton:")
    addDoneButtonToNavigationItemWithSelector("didPressDoneButton:")
    errorAlertController.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: nil))
    imageView.image = image

    
    // Check to see if camera is available
//    if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
//      for (index, button) in enumerate(toolbarItems as [UIBarButtonItem]) {
//        if button == cameraButton {
//          //toolbarItems?.removeAtIndex(index)
//        }
//      }
//    }
  }
  
  func didPressCancelButton(sender: AnyObject) -> Void {
    navigationController?.popViewControllerAnimated(true)
  }
  
  func didPressDoneButton(send: AnyObject) -> Void {
    if image == nil {
      errorAlertController.message = "Please add or take a pictore."
      presentViewController(errorAlertController, animated: true, completion: nil)
      return
    }
    delegate?.didUpdatePhoto(image!)
    navigationController?.popViewControllerAnimated(true)
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    
  }
  
  
  
  @IBAction func showImagePickerForCamera(sender: AnyObject) {
    showImagePickerForSourceType(UIImagePickerControllerSourceType.Camera)
  }

  @IBAction func showImagePickerForPhotoPicker(sender: AnyObject) {
    //     [self showImagePickerForSourceType:UIImagePickerControllerSourceTypePhotoLibrary];

    showImagePickerForSourceType(UIImagePickerControllerSourceType.PhotoLibrary)
  }
  
  func showImagePickerForSourceType(sourceType: UIImagePickerControllerSourceType) {

    
    var imagePickerController = UIImagePickerController()
    imagePickerController.modalPresentationStyle = UIModalPresentationStyle.CurrentContext
    imagePickerController.sourceType = sourceType
    imagePickerController.delegate = self
    
    if sourceType == UIImagePickerControllerSourceType.Camera {
      imagePickerController.showsCameraControls = true
//      NSBundle.mainBundle().loadNibNamed("UPMSellImageOverlay", owner: self, options: nil)
//      overlayView?.frame = (imagePickerController.cameraOverlayView?.frame)!
//      imagePickerController.cameraOverlayView = overlayView
//      overlayView = nil
    }
    self.imagePickerController = imagePickerController
    presentViewController(self.imagePickerController!, animated: true, completion: nil)

  }
  
  func finishAndUpdate() {
    dismissViewControllerAnimated(true, completion: nil)

    imageView.image = image
    self.imagePickerController = nil

  }
  
  func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
    let image: UIImage = info[UIImagePickerControllerOriginalImage] as! UIImage
    self.image = image
    finishAndUpdate()
  }
  
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
