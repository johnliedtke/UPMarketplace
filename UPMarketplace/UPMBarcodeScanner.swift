//
//  UPMBarcodeScanner.swift
//  
//
//  Created by John Liedtke on 12/22/14.
//
//

import UIKit
import AVFoundation
//TODO: Implement a delegate method to alert controller of reading a barcode...


/**
A simple barcode scanner that retrieves the number from a barcode using
the camera of the iOS device. 
*/
class UPMBarcodeScanner: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
  
  // MARK: - Properties Public
  @IBOutlet var previewView: UIView!
  @IBOutlet var statusLabel: UILabel!
  var highlightView: UIView!

  //TODO: MEOW MOEW MOEW
  ///
  var captureDevice: AVCaptureDevice!
  
  /// Indicates whether the controler is currently scanning for a barcode
  var isReading: Bool = true
  
  /// Capture session to read barcodes
  var captureSession: AVCaptureSession!
  
  /// Displays the video stream
  var videoPreviewLayer: AVCaptureVideoPreviewLayer!
  
  /// What kind of barcodes to read?
  var allowedBarcodeTypes = [AVMetadataObjectTypeEAN13Code]
  
  // MARK: Private
  var isFound = false
  
  // MARK: - Public Methods
  func startReading() -> Bool {
    var error: NSError?
    
    captureDevice = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
    
    var input = AVCaptureDeviceInput(device: captureDevice, error: &error)
    
    if input == nil {
      // No camera input
      return false
    }
    
    captureSession = AVCaptureSession()
    captureSession.addInput(input)
    
    var captureMetadataOutput = AVCaptureMetadataOutput()
    captureSession.addOutput(captureMetadataOutput)
    
    var dispatchQueue = dispatch_queue_create("captureQueue", nil)
    captureMetadataOutput.setMetadataObjectsDelegate(self, queue: dispatchQueue)
    captureMetadataOutput.metadataObjectTypes = allowedBarcodeTypes
    
    videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
    videoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
    var rect = previewView.bounds
    videoPreviewLayer.frame = previewView.bounds
    previewView.layer.addSublayer(videoPreviewLayer)
    
    // auto focus
    setupCameraFocus()
    
    captureSession.startRunning()
    
    highlightView = UIView()
    highlightView.autoresizingMask = UIViewAutoresizing.FlexibleTopMargin | UIViewAutoresizing.FlexibleLeftMargin | UIViewAutoresizing.FlexibleRightMargin | UIViewAutoresizing.FlexibleBottomMargin
    highlightView.layer.borderWidth = 3.0
    highlightView.layer.borderColor = UIColor.lightPurpleColor().CGColor

    previewView.addSubview(highlightView)
    
    return true
    
  }
  

  
  func stopReading() -> Void {
    captureSession.stopRunning()
    captureSession = nil
    videoPreviewLayer.removeFromSuperlayer()
  }
  
  func isAllowedType(type: String) -> Bool {
    for t in allowedBarcodeTypes {
      if t == type {
        return true
      }
    }
    return false
  }
  
  // MARK: Delegate
  func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
    
    var highlightViewRect = CGRectZero
    
    if metadataObjects != nil && metadataObjects.count > 0 {
      var metaDataObject = metadataObjects.first as AVMetadataMachineReadableCodeObject
      highlightViewRect = metaDataObject.bounds

      if isAllowedType(metaDataObject.type) {
        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        dispatch_async(dispatch_get_global_queue(priority, 0)) {
          // do some task
          self.isReading = false
          self.isFound = true
          //self.stopReading()


          
          dispatch_async(dispatch_get_main_queue()) {
            highlightViewRect = metaDataObject.bounds
            self.highlightView.frame = self.videoPreviewLayer.transformedMetadataObjectForMetadataObject(metaDataObject).bounds
            self.statusLabel.text = metaDataObject.stringValue
          }
        }
      }
    } else {
      isFound = false
      toggleBarCodeSquare()
    }
  }
  
  func toggleBarCodeSquare() {
    if !isFound {
      highlightView.frame = CGRectZero
    }
  }

    override func viewDidLoad() {
        super.viewDidLoad()
      
      var barcodeBox = UPMBarcodeBox()
      barcodeBox.frame = previewView.frame
      view.addSubview(barcodeBox)
      
      modalLogin()
      //startReading()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
  //TODO: Delete this
  func modalLogin() -> Void {
    var loginStoryboard = UIStoryboard(name: "UPMLogin", bundle: nil)
    var loginVC = loginStoryboard.instantiateInitialViewController() as UINavigationController
    presentViewController(loginVC, animated: true, completion: nil)
  }
  
  // MARK: Camera Focus
  
  func setupCameraFocus() -> Void {
    
    var error: NSError?
    // Lock hardware for configuration
    if captureDevice.lockForConfiguration(&error) {
      
      // auto-focus supported?
      if captureDevice.focusPointOfInterestSupported && captureDevice.isFocusModeSupported(AVCaptureFocusMode.AutoFocus) {
        // Auto-Focus
        captureDevice.focusMode = AVCaptureFocusMode.AutoFocus
      }
      
      captureDevice.unlockForConfiguration()
      
      
    } else {
      // error
    }
  }
  
  // Auto-focus on touch
  override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
    var touch = touches.anyObject() as UITouch
    var pointInView = touch.locationInView(previewView)
    
    // Check if auto-focus is supported
    if !captureDevice.focusPointOfInterestSupported && !captureDevice.isFocusModeSupported(AVCaptureFocusMode.AutoFocus) {
      return;
    }
    
    var error: NSError?
    
    if captureDevice.lockForConfiguration(&error) {
      captureDevice.focusPointOfInterest = pointInView
      captureDevice.focusMode = AVCaptureFocusMode.AutoFocus
      
      captureDevice.unlockForConfiguration()
    } else {
      // error
    }
    
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
