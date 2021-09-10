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

class LocationCell: UITableViewCell {
  @IBOutlet var descriptionLabel: UILabel!
  @IBOutlet var addressLabel: UILabel!
  @IBOutlet var photoImageView: UIImageView!

  override func awakeFromNib() {
    super.awakeFromNib()
    // Rounded corners for images
    photoImageView.layer.cornerRadius = photoImageView.bounds.size.width / 2
    photoImageView.clipsToBounds = true
    separatorInset = UIEdgeInsets(top: 0, left: 82, bottom: 0, right: 0)
  }

  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)

    // Configure the view for the selected state
  }

  // MARK: - Helper Method
  func configure(for location: Location) {
    if location.locationDescription.isEmpty {
      descriptionLabel.text = "(No Description)"
    } else {
      descriptionLabel.text = location.locationDescription
    }

    if let placemark = location.placemark {
      var text = ""
      text.add(text: placemark.subThoroughfare)
      text.add(text: placemark.thoroughfare, separatedBy: " ")
      text.add(text: placemark.locality, separatedBy: ", ")
      addressLabel.text = text
    } else {
      addressLabel.text = String(format: "Lat: %.8f, Long: %.8f", location.latitude, location.longitude)
    }

    photoImageView.image = thumbnail(for: location)
  }

  func thumbnail(for location: Location) -> UIImage {
    if location.hasPhoto, let image = location.photoImage {
      return image.resized(withBounds: CGSize(width: 52, height: 52))
    }
    return UIImage(named: "No Photo")!
  }
}
