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

class BounceAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
  func transitionDuration(
    using transitionContext: UIViewControllerContextTransitioning?
  ) -> TimeInterval {
    return 0.4
  }

  func animateTransition(
    using transitionContext: UIViewControllerContextTransitioning
  ) {
    if let toViewController = transitionContext.viewController(
      forKey: UITransitionContextViewControllerKey.to),
      let toView = transitionContext.view(
        forKey: UITransitionContextViewKey.to) {
      let containerView = transitionContext.containerView
      toView.frame = transitionContext.finalFrame(
        for: toViewController)
      containerView.addSubview(toView)
      toView.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)

      UIView.animateKeyframes(
        withDuration: transitionDuration(using: transitionContext),
        delay: 0,
        options: .calculationModeCubic,
        animations: {
          UIView.addKeyframe(
            withRelativeStartTime: 0.0,
            relativeDuration: 0.334) {
              toView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
          }
          UIView.addKeyframe(
            withRelativeStartTime: 0.334,
            relativeDuration: 0.333) {
              toView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
          }
          UIView.addKeyframe(
            withRelativeStartTime: 0.666,
            relativeDuration: 0.333) {
              toView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
          }
        }, completion: { finished in
          transitionContext.completeTransition(finished)
        })
    }
  }
}
