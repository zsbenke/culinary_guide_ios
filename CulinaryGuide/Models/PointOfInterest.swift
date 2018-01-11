//
//  PointOfInterest.swift
//  CulinaryGuide
//
//  Created by Benke Zsolt on 2018. 01. 07..
//  Copyright © 2018. Benke Zsolt. All rights reserved.
//

import Foundation
import MapKit

protocol PointOfInterest {
  var id: Int? { get }
  var title: String? { get }
  var address: String? { get }
  var latitude: String? { get }
  var longitude: String? { get }
}
