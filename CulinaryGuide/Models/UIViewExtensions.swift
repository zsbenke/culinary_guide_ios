//
//  UIViewExtensions.swift
//  CulinaryGuide
//
//  Created by Benke Zsolt on 2018. 01. 17..
//  Copyright © 2018. Benke Zsolt. All rights reserved.
//

import UIKit

extension UIView {
    var tokenColumn: String? {
        return layer.value(forKey: "column") as? String
    }
}
