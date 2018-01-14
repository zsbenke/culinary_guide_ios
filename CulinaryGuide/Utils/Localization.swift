//
//  Locale.swift
//  CulinaryGuide
//
//  Created by Benke Zsolt on 2018. 01. 11..
//  Copyright © 2018. Benke Zsolt. All rights reserved.
//

import Foundation

struct Localization {
  enum Country: String, CustomStringConvertible, EnumCollection {
    case Unknown = ""
    case CentralEurope = "all"
    case Hungary = "hu"
    case CzechRepublic = "cz"
    case Slovakia = "sk"
    case Romania = "ro"
    case Serbia = "rs"
    case Croatia = "hr"
    case Slovenia = "si"

    var description: String {
      return rawValue
    }

    var name: String {
      let unknownCountry = NSLocalizedString("Ismeretlen", comment: "Ismeretlen ország neve, nem jelenik meg a felhasználói felületben")
      switch self {
      case .Unknown:
        return unknownCountry
      case .CentralEurope:
        return NSLocalizedString("Közép-Európa", comment: "országválasztó és toolbar cím")
      case .Hungary:
        return NSLocalizedString("Magyarország", comment: "országválasztó és toolbar cím")
      case .CzechRepublic:
        return NSLocalizedString("Csehország", comment: "országválasztó és toolbar cím")
      case .Slovakia:
        return NSLocalizedString("Szlovákia", comment: "országválasztó és toolbar cím")
      case .Romania:
        return NSLocalizedString("Románia", comment: "országválasztó és toolbar cím")
      case .Serbia:
        return NSLocalizedString("Szerbia", comment: "országválasztó és toolbar cím")
      case .Croatia:
        return NSLocalizedString("Horvátország", comment: "országválasztó és toolbar cím")
      case .Slovenia:
        return NSLocalizedString("Szlovénia", comment: "országválasztó és toolbar cím")
      }
    }
  }

  enum Language: String, CustomStringConvertible {
    case unknown = ""
    case english = "en"
    case german = "de"
    case hungarian = "hu"
    case czech = "cz"
    case slovak = "sk"
    case romanian = "ro"
    case serbian = "rs"
    case croatian = "hr"
    case slovenian = "sl"

    var description: String {
      return rawValue
    }
  }

  static var currentLocale: Language {
    return localizations().first ?? Language.english
  }

  static var currentCountry: Country {
    guard let country = Country(rawValue: UserDefaults.standard.string(forKey: "\(UserDefaultKey.country)") ?? "") else { return Country.Unknown }
    return country
  }

  private static func localizations() -> [Language] {
    let supportedLocalizations = normalize(localizations: Bundle.main.localizations as [String])
    let preferredLocalizations = normalize(localizations: NSLocale.preferredLanguages)
    let localizations = preferredLocalizations.filter { supportedLocalizations.contains($0) }

    return localizations
  }

  private static func normalize(localizations: [String]) -> [Language] {
    var normalizedLocalizations = [Language]()
    for localization in localizations {
      let languageCode = String(localization.split(separator: "-")[0])
      let normalizedLanguage = normalize(localization: languageCode)
      normalizedLocalizations.append(normalizedLanguage)
    }
    return normalizedLocalizations
  }

  private static func normalize(localization: String) -> Language {
    switch localization {
    case "Base":
      return Language.english
    case "cs":
      return Language.czech
    case "sr":
      return Language.serbian
    default:
      guard let language = Language(rawValue: localization) else { return Language.unknown }
      return language
    }
  }
}
