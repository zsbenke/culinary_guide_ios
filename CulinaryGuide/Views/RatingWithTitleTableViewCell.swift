//
//  TitleWithRatingTableViewCell.swift
//  CulinaryGuide
//
//  Created by Benke Zsolt on 2018. 01. 13..
//  Copyright © 2018. Benke Zsolt. All rights reserved.
//

import UIKit

class RatingWithTitleTableViewCell: UITableViewCell {
  @IBOutlet weak var ratingImageView: UIImageView!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var detailLabel: UILabel!

  override func awakeFromNib() {
    super.awakeFromNib()
  }

  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }

  func image(forRating rating: String) -> UIImage? {
    switch rating {
    case "5":
      return #imageLiteral(resourceName: "Rating 5")
    case "4":
      return #imageLiteral(resourceName: "Rating 4")
    case "3":
      return #imageLiteral(resourceName: "Rating 3")
    case "2":
      return #imageLiteral(resourceName: "Rating 2")
    case "1":
      return #imageLiteral(resourceName: "Rating 1")
    case "pop":
      return #imageLiteral(resourceName: "Rating Pop")
    default:
      return #imageLiteral(resourceName: "Rating Pop")
    }
  }
}
