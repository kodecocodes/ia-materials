/// Copyright (c) 2020 Razeware LLC
/// 
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
/// 
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
/// 
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
/// 
/// This project and source code may use libraries or frameworks that are
/// released under various Open-Source licenses. Use of those libraries and
/// frameworks are governed by their own individual licenses.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import UIKit
import CoreLocation

private let dateFormatter: DateFormatter = {
  let formatter = DateFormatter()
  formatter.dateStyle = .medium
  formatter.timeStyle = .short
  return formatter
}()

class LocationDetailsViewController: UITableViewController {
  @IBOutlet weak var descriptionTextView: UITextView!
  @IBOutlet weak var categoryLabel: UILabel!
  @IBOutlet weak var latitudeLabel: UILabel!
  @IBOutlet weak var longitudeLabel: UILabel!
  @IBOutlet weak var addressLabel: UILabel!
  @IBOutlet weak var dateLabel: UILabel!

  var coordinate = CLLocationCoordinate2D(latitude: 0, longitude: 0)
  var placemark: CLPlacemark?
  var categoryName = "No Category"

  override func viewDidLoad() {
    super.viewDidLoad()

    descriptionTextView.text = ""
    categoryLabel.text = categoryName

    latitudeLabel.text = String(format: "%.8f", coordinate.latitude)
    longitudeLabel.text = String(format: "%.8f", coordinate.longitude)

    if let placemark = placemark {
      addressLabel.text = string(from: placemark)
    } else {
      addressLabel.text = "No Address Found"
    }

    dateLabel.text = format(date: Date())
    // Hide keyboard
    let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
    gestureRecognizer.cancelsTouchesInView = false
    tableView.addGestureRecognizer(gestureRecognizer)
  }

  // MARK: - Navigation
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "PickCategory" {
      let controller = segue.destination as! CategoryPickerViewController
      controller.selectedCategoryName = categoryName
    }
  }

  // MARK: - Actions
  @IBAction func done() {
    guard let mainView = navigationController?.parent?.view else { return }
    let hudView = HudView.hud(inView: mainView, animated: true)
    hudView.text = "Tagged"
    afterDelay(0.6) {
      hudView.hide()
      self.navigationController?.popViewController(animated: true)
    }
  }

  @IBAction func cancel() {
    navigationController?.popViewController(animated: true)
  }

  @IBAction func categoryPickerDidPickCategory(_ segue: UIStoryboardSegue) {
    let controller = segue.source as! CategoryPickerViewController
    categoryName = controller.selectedCategoryName
    categoryLabel.text = categoryName
  }

  // MARK: - Helper Methods
  func string(from placemark: CLPlacemark) -> String {
    var text = ""

    if let tmp = placemark.subThoroughfare {
      text += tmp + " "
    }
    if let tmp = placemark.thoroughfare {
      text += tmp + ", "
    }
    if let tmp = placemark.locality {
      text += tmp + ", "
    }
    if let tmp = placemark.administrativeArea {
      text += tmp + " "
    }
    if let tmp = placemark.postalCode {
      text += tmp + ", "
    }
    if let tmp = placemark.country {
      text += tmp
    }
    return text
  }

  func format(date: Date) -> String {
    return dateFormatter.string(from: date)
  }

  @objc func hideKeyboard(_ gestureRecognizer: UIGestureRecognizer) {
    let point = gestureRecognizer.location(in: tableView)
    let indexPath = tableView.indexPathForRow(at: point)

    if indexPath != nil && indexPath!.section == 0 && indexPath!.row == 0 {
      return
    }
    descriptionTextView.resignFirstResponder()
  }

  // MARK: - Table View Delegates
  override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
    if indexPath.section == 0 || indexPath.section == 1 {
      return indexPath
    } else {
      return nil
    }
  }

  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if indexPath.section == 0 && indexPath.row == 0 {
      descriptionTextView.becomeFirstResponder()
    }
  }
}
