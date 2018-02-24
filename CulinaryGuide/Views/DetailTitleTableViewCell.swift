//
//  DetailTitleTableViewCell.swift
//  CulinaryGuide
//
//  Created by Benke Zsolt on 2018. 02. 23..
//  Copyright © 2018. Benke Zsolt. All rights reserved.
//

import UIKit

class DetailTitleTableViewCell: UITableViewCell {
    @IBOutlet weak var heroImageView: UIImageView!
    @IBOutlet weak var ratingContainerView: UIView!
    @IBOutlet weak var ratingView: UIView!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!

    override func awakeFromNib() {
        let maskPath = UIBezierPath.init(roundedRect: yearLabel.bounds, byRoundingCorners:[.bottomLeft, .bottomRight], cornerRadii: CGSize.init(width: 5, height: 5))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = yearLabel.bounds
        maskLayer.path = maskPath.cgPath
        yearLabel.layer.mask = maskLayer

        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
    }
}
