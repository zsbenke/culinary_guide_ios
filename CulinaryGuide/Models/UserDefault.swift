//
//  UserDefault.swift
//  CulinaryGuide
//
//  Created by Benke Zsolt on 2018. 01. 12..
//  Copyright © 2018. Benke Zsolt. All rights reserved.
//

import Foundation

enum UserDefaultKey: String, CustomStringConvertible {
  case country = "Country"

  var description: String {
    return rawValue
  }
}
