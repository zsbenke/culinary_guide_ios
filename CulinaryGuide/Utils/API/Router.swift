//
//  Router.swift
//  CulinaryGuide
//
//  Created by Benke Zsolt on 2018. 01. 07..
//  Copyright © 2018. Benke Zsolt. All rights reserved.
//

import Foundation

protocol Router {
  static var baseURLEndpoint: String { get }
  func asURLRequest() -> URLRequest
}
