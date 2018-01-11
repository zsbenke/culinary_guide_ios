//
//  API.swift
//  CulinaryGuide
//
//  Created by Benke Zsolt on 2018. 01. 07..
//  Copyright © 2018. Benke Zsolt. All rights reserved.
//

import Foundation

enum Environment {
  case production
  case staging
  case development
}

struct API {
  static var environment: Environment = .development
  private static var domain: String {
    switch environment {
    case .development:
      return "http://develop.decoding.io:3000"
    case .production:
      return "http://api.gaultmillau.eu"
    case .staging:
      return "http://api.staging.gaultmillau.eu"
    }
  }

  static let baseURL = "\(domain)/api/v1"
}
