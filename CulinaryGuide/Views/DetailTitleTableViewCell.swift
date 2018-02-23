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
        super.awakeFromNib()

        ratingContainerView.layer.cornerRadius = 5
        ratingContainerView.clipsToBounds = true
        ratingContainerView.layer.borderColor = UIColor.gray.cgColor
        ratingContainerView.layer.borderWidth = 0.5
        ratingView.backgroundColor = .white

        yearLabel.backgroundColor = UIColor.BrandColor.primary
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
    }

}
