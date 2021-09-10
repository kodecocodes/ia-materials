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

class ViewController: UIViewController {
  @IBOutlet weak var slider: UISlider!
  @IBOutlet weak var targetLabel: UILabel!
  @IBOutlet weak var scoreLabel: UILabel!
  @IBOutlet weak var roundLabel: UILabel!

  var currentValue = 0
  var targetValue = 0
  var score = 0
  var round = 0

  override func viewDidLoad() {
    super.viewDidLoad()

    let thumbImageNormal = UIImage(named: "SliderThumb-Normal")!
    slider.setThumbImage(thumbImageNormal, for: .normal)

    let thumbImageHighlighted = UIImage(named: "SliderThumb-Highlighted")!
    slider.setThumbImage(thumbImageHighlighted, for: .highlighted)

    let insets = UIEdgeInsets(top: 0, left: 14, bottom: 0, right: 14)

    let trackLeftImage = UIImage(named: "SliderTrackLeft")!
    let trackLeftResizable =
      trackLeftImage.resizableImage(withCapInsets: insets)
    slider.setMinimumTrackImage(trackLeftResizable, for: .normal)

    let trackRightImage = UIImage(named: "SliderTrackRight")!
    let trackRightResizable =
      trackRightImage.resizableImage(withCapInsets: insets)
    slider.setMaximumTrackImage(trackRightResizable, for: .normal)

    startNewGame()
  }

  @IBAction func showAlert() {
    let difference = abs(targetValue - currentValue)
    var points = 100 - difference

    let title: String
    if difference == 0 {
      title = "Perfect!"
      points += 100
    } else if difference < 5 {
      title = "You almost had it!"
      if difference == 1 {
        points += 50
      }
    } else if difference < 10 {
      title = "Pretty good!"
    } else {
      title = "Not even close..."
    }
    score += points
    let message = "You scored \(points) points"

    let alert = UIAlertController(
      title: title,
      message: message,
      preferredStyle: .alert)

    let action = UIAlertAction(
      title: "OK",
      style: .default) {_ in
      self.startNewRound()
    }

    alert.addAction(action)
    present(alert, animated: true, completion: nil)
  }

  @IBAction func sliderMoved(_ slider: UISlider) {
    currentValue = lroundf(slider.value)
  }

  @IBAction func startNewGame() {
    score = 0
    round = 0
    startNewRound()
  }

  func startNewRound() {
    round += 1
    targetValue = Int.random(in: 1...100)
    currentValue = 50
    slider.value = Float(currentValue)
    updateLabels()
  }

  func updateLabels() {
    targetLabel.text = String(targetValue)
    scoreLabel.text = String(score)
    roundLabel.text = String(round)
  }
}
