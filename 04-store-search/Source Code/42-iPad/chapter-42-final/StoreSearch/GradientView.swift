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

class GradientView: UIView {
  override init(frame: CGRect) {
    super.init(frame: frame)
    backgroundColor = UIColor.clear
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    backgroundColor = UIColor.clear
  }

  override func draw(_ rect: CGRect) {
    let traits = UITraitCollection.current
    let color: CGFloat = traits.userInterfaceStyle == .light ? 0.314 : 1
    let components: [CGFloat] = [
      color, color, color, 0.2,
      color, color, color, 0.4,
      color, color, color, 0.6,
      color, color, color, 1
    ]
    let locations: [CGFloat] = [ 0, 0.5, 0.75, 1 ]
    let colorSpace = CGColorSpaceCreateDeviceRGB()
    let gradient = CGGradient(colorSpace: colorSpace, colorComponents: components, locations: locations, count: 4)
    let x = bounds.midX
    let y = bounds.midY
    let centerPoint = CGPoint(x: x, y: y)
    let radius = max(x, y)
    let context = UIGraphicsGetCurrentContext()
    context?.drawRadialGradient(gradient!, startCenter: centerPoint, startRadius: 0, endCenter: centerPoint, endRadius: radius, options: .drawsAfterEndLocation)
  }
}
