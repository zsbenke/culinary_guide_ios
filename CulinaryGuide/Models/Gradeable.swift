//
//  Rateable.swift
//  CulinaryGuide
//
//  Created by Benke Zsolt on 2018. 01. 16..
//  Copyright © 2018. Benke Zsolt. All rights reserved.
//

import UIKit

protocol Gradeable {
    var points: String { get set }
    var image: UIImage { get }
    var color: UIColor { get }
}
