//
//  EnumCollection.swift
//  CulinaryGuide
//
//  Created by Benke Zsolt on 2018. 01. 11..
//  Copyright © 2018. Benke Zsolt. All rights reserved.
//

import Foundation

protocol EnumCollection : Hashable {}

extension EnumCollection {
  static func cases() -> AnySequence<Self> {
    typealias S = Self
    return AnySequence { () -> AnyIterator<S> in
      var raw = 0
      return AnyIterator {
        let current : Self = withUnsafePointer(to: &raw) { $0.withMemoryRebound(to: S.self, capacity: 1) { $0.pointee } }
        guard current.hashValue == raw else { return nil }
        raw += 1
        return current
      }
    }
  }
}
