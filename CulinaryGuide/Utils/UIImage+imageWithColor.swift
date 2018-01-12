//
//  UIImage+imageWithColor.swift
//  CulinaryGuide
//
//  Created by Benke Zsolt on 2018. 01. 12..
//  Copyright © 2018. Benke Zsolt. All rights reserved.
//

import UIKit

extension UIImage {
  class func imageWithColor(color:UIColor?) -> UIImage! {
    let rect = CGRect.init(x: 0, y: 0, width: 1.0, height: 1.0)

    UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)

    let context = UIGraphicsGetCurrentContext()

    if let color = color {
      color.setFill()
    } else {
      UIColor.white.setFill()
    }

    if let context = context {
      context.fill(rect)
    }

    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()

    return image
  }
}
