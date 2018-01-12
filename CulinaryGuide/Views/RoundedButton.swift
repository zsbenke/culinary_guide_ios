//
//  RoundedButton.swift
//  CulinaryGuide
//
//  Created by Benke Zsolt on 2018. 01. 12..
//  Copyright © 2018. Benke Zsolt. All rights reserved.
//

import UIKit

class RoundedButton: UIButton {
  override func awakeFromNib() {
    super.awakeFromNib()

    self.backgroundColor = UIColor.red
    self.contentEdgeInsets = UIEdgeInsets(top: 15.0, left: 15.0, bottom: 15.0, right: 15.0)
    self.layer.cornerRadius = 3
    self.layer.masksToBounds = true
    setTitleColor(UIColor.BrandColor.light, for: .normal)
    setTitleColor(UIColor.BrandColor.lightHighlighted, for: .highlighted)
    setBackgroundImage(UIImage.imageWithColor(color: UIColor.BrandColor.primary), for: .normal)
    setBackgroundImage(UIImage.imageWithColor(color: UIColor.BrandColor.primaryHighlighted), for: .highlighted)
    self.titleLabel?.font = UIFont.boldSystemFont(ofSize: UIFont.systemFontSize)
  }
}
