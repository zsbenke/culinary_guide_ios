//
//  PartialModalAnimator.swift
//  CulinaryGuide
//
//  Created by Benke Zsolt on 2018. 01. 12..
//  Copyright © 2018. Benke Zsolt. All rights reserved.
//

import UIKit

class PartialModalPresentationAnimator: NSObject, UIViewControllerAnimatedTransitioning {
  func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    return 0.3
  }

  func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    let toViewController = transitionContext.viewController(forKey: .to)!
    let containerView = transitionContext.containerView
    let animationDuration = transitionDuration(using: transitionContext)

    toViewController.view.transform = CGAffineTransform.init(translationX: 0, y: toViewController.view.bounds.height)
    toViewController.view.clipsToBounds = true
    containerView.addSubview(toViewController.view)
    UIView.animate(withDuration: animationDuration, delay: 0.0, options: .curveEaseOut, animations: {
      toViewController.view.transform = CGAffineTransform.identity
    }) { finished in
      transitionContext.completeTransition(finished)
    }
  }
}
