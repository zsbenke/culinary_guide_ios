//
//  TitleWithRatingTableViewCell.swift
//  CulinaryGuide
//
//  Created by Benke Zsolt on 2018. 01. 13..
//  Copyright © 2018. Benke Zsolt. All rights reserved.
//

import UIKit

class RatingWithTitleTableViewCell: UITableViewCell {
    @IBOutlet weak var ratingView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
