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

class HudView: UIView {
  var text = ""

  class func hud(inView view: UIView, animated: Bool) -> HudView {
    let hudView = HudView(frame: view.bounds)
    hudView.isOpaque = false

    view.addSubview(hudView)
    view.isUserInteractionEnabled = false
    hudView.show(animated: animated)
    return hudView
  }

  override func draw(_ rect: CGRect) {
    let boxWidth: CGFloat = 96
    let boxHeight: CGFloat = 96

    let boxRect = CGRect(x: round((bounds.size.width - boxWidth) / 2), y: round((bounds.size.height - boxHeight) / 2), width: boxWidth, height: boxHeight)

    let roundedRect = UIBezierPath(roundedRect: boxRect, cornerRadius: 10)
    UIColor(white: 0.3, alpha: 0.8).setFill()
    roundedRect.fill()
    // Draw checkmark
    guard let image = UIImage(named: "Checkmark") else { return }
    let imagePoint = CGPoint(x: center.x - round(image.size.width / 2), y: center.y - round(image.size.height / 2) - boxHeight / 8)
    image.draw(at: imagePoint)
    // Draw the text
    let attribs = [
      NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16),
      NSAttributedString.Key.foregroundColor: UIColor.white
    ]

    let textSize = text.size(withAttributes: attribs)

    let textPoint = CGPoint(x: center.x - round(textSize.width / 2), y: center.y - round(textSize.height / 2) + boxHeight / 4)
    text.draw(at: textPoint, withAttributes: attribs)
  }

  // MARK: - Public methods
  func show(animated: Bool) {
    if animated {
      alpha = 0
      transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
      UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: [], animations: {
          self.alpha = 1
          self.transform = CGAffineTransform.identity
        }, completion: nil)
    }
  }

  func hide() {
    superview?.isUserInteractionEnabled = true
    removeFromSuperview()
  }
}
