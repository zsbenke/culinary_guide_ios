//
//  Locale.swift
//  CulinaryGuide
//
//  Created by Benke Zsolt on 2018. 01. 11..
//  Copyright © 2018. Benke Zsolt. All rights reserved.
//

import Foundation

struct Localization {
  static var current: String {
    get {
      return localizations().first ?? "en"
    }
  }

  private static func localizations() -> [String] {
    let supportedLocalizations = normalize(localizations: Bundle.main.localizations as [String])
    let preferredLocalizations = normalize(localizations: NSLocale.preferredLanguages)
    let localizations = preferredLocalizations.filter { supportedLocalizations.contains($0) }

    return localizations
  }

  private static func normalize(localizations: [String]) -> [String] {
    var normalizedLocalizations = [String]()
    for localization in localizations {
      let languageCode = String(localization.split(separator: "-")[0])
      var normalizedLanguageCode = ""

      switch languageCode {
      case "sr":
        normalizedLanguageCode = "rs"
      case "cs":
        normalizedLanguageCode = "cz"
      case "Base":
        normalizedLanguageCode = "en"
      default:
        normalizedLanguageCode = languageCode
      }

      normalizedLocalizations.append(normalizedLanguageCode)
    }
    return normalizedLocalizations
  }
}
