//
//  Rating.swift
//  CulinaryGuide
//
//  Created by Benke Zsolt on 2018. 01. 16..
//  Copyright © 2018. Benke Zsolt. All rights reserved.
//

import UIKit

struct RestaurantRating: Gradeable {
    var points: String
    var color: UIColor {
        if image == #imageLiteral(resourceName: "Rating Pop") {
            return UIColor.BrandColor.primary
        }
        return UIColor.BrandColor.secondary
    }
    var image: UIImage {
        var image = UIImage()

        switch points {
        case "5":
            image = #imageLiteral(resourceName: "Rating 5")
        case "4":
            image = #imageLiteral(resourceName: "Rating 4")
        case "3":
            image = #imageLiteral(resourceName: "Rating 3")
        case "2":
            image = #imageLiteral(resourceName: "Rating 2")
        case "1":
            image = #imageLiteral(resourceName: "Rating 1")
        case "pop":
            image = #imageLiteral(resourceName: "Rating Pop")
        default:
            image = #imageLiteral(resourceName: "Rating Pop")
        }

        return image
    }
}
