//
//  TagCollectionViewCell.swift
//  CulinaryGuide
//
//  Created by Benke Zsolt on 2018. 01. 13..
//  Copyright © 2018. Benke Zsolt. All rights reserved.
//

import UIKit

class TagCollectionViewCell: UICollectionViewCell {
  @IBOutlet weak var labelView: UILabel!
  @IBOutlet weak var labelViewMaxWidthConstraint: NSLayoutConstraint!

  override func awakeFromNib() {
    super.awakeFromNib()

    self.layer.cornerRadius = 5
    self.backgroundColor = UIColor(red: 0.91, green: 0.91, blue: 0.92, alpha:1.0)
    self.labelViewMaxWidthConstraint.constant = UIScreen.main.bounds.width - 10 * 2 - 10 * 2
  }
}
