//
//  DetailTitleTableViewCell.swift
//  CulinaryGuide
//
//  Created by Benke Zsolt on 2018. 02. 23..
//  Copyright © 2018. Benke Zsolt. All rights reserved.
//

import UIKit

class DetailTitleView: UIView {
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var heroImageView: UIImageView!
    @IBOutlet weak var heroImageGradient: UIImageView!
    @IBOutlet weak var ratingContainerView: UIView!
    @IBOutlet weak var ratingView: UIView!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!

    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadViewFromNib()
    }

    private func loadViewFromNib() {
        Bundle.main.loadNibNamed("DetailTitleView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]

        let maskPath = UIBezierPath.init(roundedRect: yearLabel.bounds, byRoundingCorners:[.bottomLeft, .bottomRight], cornerRadii: CGSize.init(width: 5, height: 5))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = yearLabel.bounds
        maskLayer.path = maskPath.cgPath
        yearLabel.layer.mask = maskLayer
    }
}
