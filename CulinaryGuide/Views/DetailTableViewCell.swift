//
//  DetailTableViewCell.swift
//  CulinaryGuide
//
//  Created by Benke Zsolt on 2018. 03. 01..
//  Copyright © 2018. Benke Zsolt. All rights reserved.
//

import UIKit

class DetailTableViewCell: UITableViewCell {
    @IBOutlet weak var labelText: UILabel!
    @IBOutlet weak var valueText: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
