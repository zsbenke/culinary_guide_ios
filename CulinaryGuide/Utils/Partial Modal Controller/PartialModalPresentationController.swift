//
//  PartialModalPresentationController.swift
//  CulinaryGuide
//
//  Created by Benke Zsolt on 2018. 01. 12..
//  Copyright © 2018. Benke Zsolt. All rights reserved.
//

import UIKit

class PartialModalPresentationController: UIPresentationController {
  var height: CGFloat = 200

  override var frameOfPresentedViewInContainerView: CGRect {
    return CGRect(x: 0, y: containerView!.bounds.height - height, width: containerView!.bounds.width, height: height)
  }

  override func containerViewWillLayoutSubviews() {
    presentedView?.frame = frameOfPresentedViewInContainerView
  }

  override func presentationTransitionWillBegin() {
    super.presentationTransitionWillBegin()
  }
}
