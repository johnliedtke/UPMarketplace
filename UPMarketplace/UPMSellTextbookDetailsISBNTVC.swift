import UIKit

/// Used to communicate changes to a textbook's ISBN
protocol UPMSellTextbookDetailsISBNDelegate: class {
  /// Called when the user has finished updating the ISBN of a textbook. 
  /// That is, when the user selects done and the controller is popped from
  /// the navigation stack.
  ///
  /// :returns: An updated unformatted ISBN.
  func didISBNUpdate(unformattedISBN: String?)
}

/// Used to collect and update the ISBN of a UPMTextbook. Contains
/// one textfield used to collect user-input of an ISBN.
class UPMSellTextbookDetailsISBNTVC: UITableViewController, UITextFieldDelegate, UPMSellCheckInput {
  
  // MARK: Properties
  /// Delegate controller to handle ISBN updates
  weak var delegate: UPMSellTextbookDetailsISBNDelegate?
  
  /// Reference to the textfield used to collect the ISBN of a textbook.
  @IBOutlet var iSBNField: UITextField!
  
  /// The current ISBN. Used to intialize :iSBNField:.
  ///
  /// * Set before being pushed.
  var iSBN: String = ""
  
  var alertController = UIAlertController(title: "Error", message: "Problem", preferredStyle: UIAlertControllerStyle.Alert)
  
  
  // MARK: Methods
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.estimatedRowHeight = 50.0 // simulator auto-layout fix
    addDoneButtonToNavigationItemWithSelector("didPressDoneButton:")
    addCancelButtontToNavigationItemWithSelector("didPressCancelButton:")
    tableView.backgroundColor = UIColor.standardBackgroundColor()
    iSBNField.becomeFirstResponder()
    iSBNField.text = iSBN
  }
  
  /// Notifies delegate of updated ISBN and pops controller n-stack.
  func didPressDoneButton(sender: AnyObject) {
    view.endEditing(true)
    delegate?.didISBNUpdate(iSBN)
    navigationController?.popViewControllerAnimated(true)
  }
  
  /// User cancels edits and pops the controller from the navigation stack
  func didPressCancelButton(sender: AnyObject) {
    navigationController?.popViewControllerAnimated(true)
  }
  
  // MARK: Delegate Methods
  func textFieldDidEndEditing(textField: UITextField) {
    if textField == iSBNField {
      iSBN = textField.text
    }
  }
  
  // TODO: Validation
  
  func alertIfInputError() -> Bool {
    return true;
  }
  
  func validateInput() -> String {
    return ""
  }
  
  func addActionItemsToAlertController() {
    
  }
  
  

}
