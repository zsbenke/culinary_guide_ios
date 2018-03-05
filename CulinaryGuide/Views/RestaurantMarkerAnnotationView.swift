//
//  RestaurantMarkerAnnotationView.swift
//  CulinaryGuide
//
//  Created by Benke Zsolt on 2018. 03. 05..
//  Copyright © 2018. Benke Zsolt. All rights reserved.
//

import UIKit
import MapKit

class RestaurantMarkerAnnotationView: MKMarkerAnnotationView {
    override var annotation: MKAnnotation? {
        willSet {
            newValue.flatMap(configure(with:))
        }
    }
}

private extension RestaurantMarkerAnnotationView {
    func configure(with annotation: MKAnnotation) {
        guard let annotation = annotation as? RestaurantAnnotation else { return }
        if let restaurantRating = annotation.restaurant.rating {
            canShowCallout = true
            let rating = RestaurantRating(points: restaurantRating)
            glyphImage = rating.image
            markerTintColor = rating.color
            leftCalloutAccessoryView = RatingView(rating: rating)
            rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        } else {
            markerTintColor = UIColor.BrandColor.primary
            glyphImage = #imageLiteral(resourceName: "Facet Restaurant")
        }
        clusteringIdentifier = String(describing: RestaurantMarkerAnnotationView.self)
    }
}
