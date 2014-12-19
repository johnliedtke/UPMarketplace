import UIKit

/// Used to communicate changes to a textbook's course
protocol UPMSellTextbookDetailsCourseDelegate {
  /// Called when the user has finished updating the course of a textbook.
  /// That is, when the user selects done and the controller is popped from
  /// the navigation stack.
  ///
  /// :returns: An updated course.
  func didCourseUpdate(course: String?)
}

/// Used to collect and update the course of a UPMTextbook. Contains
/// one textfield used to collect user-input of an course.
class UPMSellTextbookDetailsCourseTVC: UITableViewController, UITextFieldDelegate, UPMSellCheckInput {
  
  // MARK: - Properties
  /// Delegate controller to handle course updates
  var delegate: UPMSellTextbookDetailsCourseDelegate?
  
  /// Reference to the textfield used to collect the course that used textbook.
  @IBOutlet var courseField: UITextField!
  
  /// The current course. Used to intialize :courseField:.
  ///
  /// * Set before being pushed.
  var course: String = ""
  
  var alertController = UIAlertController(title: "Error", message: "Problem", preferredStyle: UIAlertControllerStyle.Alert)
  
  
  // MARK: - Methods
  override func viewDidLoad() {
    super.viewDidLoad()
    addDoneButtonToNavigationItemWithSelector("didPressDoneButton:")
    addCancelButtontToNavigationItemWithSelector("didPressCancelButton:")
    tableView.backgroundColor = UIColor.standardBackgroundColor()
    courseField.becomeFirstResponder()
    courseField.text = course
  }
  
  /// Notifies delegate of updated course and pops controller from n-stack.
  func didPressDoneButton(sender: AnyObject) {
    view.endEditing(true)
    delegate?.didCourseUpdate(course)
    navigationController?.popViewControllerAnimated(true)
  }
  
  /// User cancels edits and pops the controller from the navigation stack
  func didPressCancelButton(sender: AnyObject) {
    navigationController?.popViewControllerAnimated(true)
  }
  
  // MARK: Delegate Methods
  func textFieldDidEndEditing(textField: UITextField) {
    if textField == courseField {
      course = textField.text
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
