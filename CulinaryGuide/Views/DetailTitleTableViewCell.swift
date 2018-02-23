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
    @IBOutlet weak var ratingView: UIView!
    @IBOutlet weak var titleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
    }

}
