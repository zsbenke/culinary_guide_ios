//
//  PartialModalTransitionDelegate.swift
//  CulinaryGuide
//
//  Created by Benke Zsolt on 2018. 01. 12..
//  Copyright © 2018. Benke Zsolt. All rights reserved.
//

import UIKit

class PartialModalTransitionDelegate: NSObject, UIViewControllerTransitioningDelegate {
  var modalHeight: CGFloat = 200

  func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
    let partialModalPresentationController = PartialModalPresentationController(presentedViewController: presented, presenting: presenting)
    partialModalPresentationController.height = modalHeight
    return partialModalPresentationController
  }

  func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    return PartialModalPresentationAnimator()
  }

  func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    return PartialModalDismissAnimator()
  }
}
