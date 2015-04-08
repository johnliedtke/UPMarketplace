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

public protocol UPMBarcodeScannerDelegate: class {
  
  /**
  Called when a barcode is found. Reading has been halted when this method is called.
  
  :param: barcode String represenation of barcode.
  */
  func didReadBarcode(barcode: String, shouldUseBarCode: Bool) -> Void
  
}

/**
  A simple barcode scanner that retrieves the number from a barcode using
  the camera of the iOS device.
*/
public class UPMBarcodeScanner: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
  
  // MARK: - Public Properties
  @IBOutlet var previewView: UIView!
  @IBOutlet var statusLabel: UILabel!
  var highlightView: UIView!
  
  /// Receives notifications when a code is read
  public weak var delegate: UPMBarcodeScannerDelegate?
  
  /// What kind of barcodes to read?
  public var allowedBarcodeTypes = [AVMetadataObjectTypeEAN13Code]
  
  /// Barcode read handler
  public var barcodeReadHandler: ((isbn: String) -> BFTask)?
  
  // MARK: - Private Properties
  
  /// Found a barcode
  private var isFound = false
  
  /// Device for capturing video.
  private var captureDevice: AVCaptureDevice!
  
  /// Indicates whether the controler is currently scanning for a barcode
  private var isReading: Bool = true
  
  /// Capture session to read barcodes
  private var captureSession: AVCaptureSession!
  
  /// Displays the video stream
  private var videoPreviewLayer: AVCaptureVideoPreviewLayer!

  // MARK: - Public Methods
  
  override public func viewDidLoad() {
    super.viewDidLoad()
    var barcodeBox = UPMBarcodeBox()
    previewView = UIView(frame: self.view.frame)
    view.addSubview(previewView)
    barcodeBox.frame = previewView.frame
    view.addSubview(barcodeBox)
    
    navigationItem.title = "Scan"
    navigationItem.setLeftBarButtonItem(UIBarButtonItem(title: "Cancel", style: .Plain, target: self, action: "didPressCancel"), animated: true)
    
    startReading()
    // Do any additional setup after loading the view.
  }
  
  func didPressCancel() {
    dismissViewControllerAnimated(true, completion: nil)
  }
  
  /// Halts capture session and stops reading barcodes.
  public func stopReading() -> Void {
    captureSession.stopRunning()
    captureSession = nil
    videoPreviewLayer.removeFromSuperlayer()
  }
  
  /**
  Begin reading bar codes. Finds a camera device to read bar codes, does nothing
  if no camera device is found.
  
  :returns: Found a camera device and began reading
  */
  public func startReading() -> Bool {
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

  /// Checks if the barcode scanned was a valid barcode.
  private func isAllowedType(type: String) -> Bool {
    for t in allowedBarcodeTypes {
      if t == type {
        return true
      }
    }
    return false
  }
  
  // MARK: - Delegate
  public func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
    
    var highlightViewRect = CGRectZero
    
    if metadataObjects != nil && metadataObjects.count > 0 {
      var metaDataObject = metadataObjects.first as AVMetadataMachineReadableCodeObject
      highlightViewRect = metaDataObject.bounds

      if isAllowedType(metaDataObject.type) {
        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        dispatch_async(dispatch_get_global_queue(priority, 0)) { [weak self] in
        if let weakSelf = self {

          // do some task
          weakSelf.isReading = false
          weakSelf.isFound = true
          
          
          weakSelf.stopReading()
          //self.delegate?.didReadBarcode(metaDataObject.stringValue)
          if let handler = weakSelf.barcodeReadHandler {
            handler(isbn: metaDataObject.stringValue).continueWithExecutor(BFExecutor.mainThreadExecutor(), withBlock: {
              (task) in
              
              
                var message = ""
                if let msg = task.result as? String {
                  message = msg
                } else {
                  message = task.error.localizedDescription
                }
                
                var alertController = UIAlertController(title: "Found!", message: message, preferredStyle: .Alert)
                
                alertController.addAction(UIAlertAction(title: "Cancel", style: .Destructive) {
                  (action) in
                  weakSelf.dismissViewControllerAnimated(true, completion: nil)
                  })
                alertController.addAction(UIAlertAction(title: "Rescan", style: .Default) {
                  (action) in
                  weakSelf.startReading()
                  return
                })
                alertController.addAction(UIAlertAction(title: "Done", style: .Cancel) {
                  (action) in
                  if task.error == nil {
                    weakSelf.delegate?.didReadBarcode(metaDataObject.stringValue, shouldUseBarCode: true)
                  }
                  weakSelf.dismissViewControllerAnimated(true, completion: nil)
                })
                
                weakSelf.presentViewController(alertController, animated: true, completion: nil)
              
              return nil
            })
           
          }
          
          
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

  public func didReadBarcode(barcode: String) {
    var alertController = UIAlertController(title: "Found!", message: barcode, preferredStyle: .Alert)
    var okayAction = UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default) {
      (a: UIAlertAction!) -> Void in
      self.startReading()
      return
    }
    alertController.addAction(okayAction)
    presentViewController(alertController, animated: true, completion: nil)
  }
  
  // MARK: - Camera Focus
  
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

    override public func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        
        if let touch = event.allTouches()?.anyObject() as? UITouch {
            
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
    }
  
}
