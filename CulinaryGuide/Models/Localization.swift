import Foundation
import MapKit

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
            let unknownCountry = NSLocalizedString("Unknown", comment: "Ismeretlen ország neve, nem jelenik meg a felhasználói felületben")
            switch self {
            case .Unknown:
                return unknownCountry
            case .CentralEurope:
                return NSLocalizedString("Central Europe", comment: "országválasztó és toolbar cím")
            case .Hungary:
                return NSLocalizedString("Hungary", comment: "országválasztó és toolbar cím")
            case .CzechRepublic:
                return NSLocalizedString("Czech Republic", comment: "országválasztó és toolbar cím")
            case .Slovakia:
                return NSLocalizedString("Slovakia", comment: "országválasztó és toolbar cím")
            case .Romania:
                return NSLocalizedString("Romania", comment: "országválasztó és toolbar cím")
            case .Serbia:
                return NSLocalizedString("Serbia", comment: "országválasztó és toolbar cím")
            case .Croatia:
                return NSLocalizedString("Croatia", comment: "országválasztó és toolbar cím")
            case .Slovenia:
                return NSLocalizedString("Slovenia", comment: "országválasztó és toolbar cím")
            }
        }

        var defaultRegion: MKCoordinateRegion {
            switch self {
            case .Hungary:
                let center = CLLocationCoordinate2D(latitude: 47.162494, longitude: 19.50330400000007)
                let span = MKCoordinateSpan(latitudeDelta: 7.7, longitudeDelta: 0)
                return MKCoordinateRegion(center: center, span: span)
            case .CzechRepublic:
                let center = CLLocationCoordinate2D(latitude: 49.81749199999999, longitude: 15.472962000000052)
                let span = MKCoordinateSpan(latitudeDelta: 7.7, longitudeDelta: 0)
                return MKCoordinateRegion(center: center, span: span)
            case .Slovakia:
                let center = CLLocationCoordinate2D(latitude: 48.669026, longitude: 19.69902400000001)
                let span = MKCoordinateSpan(latitudeDelta: 6.25, longitudeDelta: 0)
                return MKCoordinateRegion(center: center, span: span)
            case .Romania:
                let center = CLLocationCoordinate2D(latitude: 45.943161, longitude: 24.966760000000022)
                let span = MKCoordinateSpan(latitudeDelta: 10, longitudeDelta: 0)
                return MKCoordinateRegion(center: center, span: span)
            case .Serbia:
                let center = CLLocationCoordinate2D(latitude: 44.016521, longitude: 21.005858999999987)
                let span = MKCoordinateSpan(latitudeDelta: 0, longitudeDelta: 6)
                return MKCoordinateRegion(center: center, span: span)
            case .Croatia:
                let center = CLLocationCoordinate2D(latitude: 44.779378823315433, longitude: 16.474812199573179)
                let span = MKCoordinateSpan(latitudeDelta: 7.7, longitudeDelta: 0)
                return MKCoordinateRegion(center: center, span: span)
            case .Slovenia:
                let center = CLLocationCoordinate2D(latitude: 46.151241, longitude: 14.995462999999972)
                let span = MKCoordinateSpan(latitudeDelta: 4.5, longitudeDelta: 0)
                return MKCoordinateRegion(center: center, span: span)
            default:
                let center = CLLocationCoordinate2D(latitude: 46.253560162029316, longitude: 19.71885626901096)
                let span = MKCoordinateSpan(latitudeDelta: 19.2, longitudeDelta: 0)
                return MKCoordinateRegion(center: center, span: span)
            }
        }

        var homeHeroImage: UIImage {
            switch self {
            case .Hungary:
                return #imageLiteral(resourceName: "Home Title Image Hungary")
            default:
                return #imageLiteral(resourceName: "Home Title Image Hungary")
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
}

private extension Localization {
    static func localizations() -> [Language] {
        let supportedLocalizations = normalize(localizations: Bundle.main.localizations as [String])
        let preferredLocalizations = normalize(localizations: NSLocale.preferredLanguages)
        let localizations = preferredLocalizations.filter { supportedLocalizations.contains($0) }

        return localizations
    }

    static func normalize(localizations: [String]) -> [Language] {
        var normalizedLocalizations = [Language]()
        for localization in localizations {
            let languageCode = String(localization.split(separator: "-")[0])
            let normalizedLanguage = normalize(localization: languageCode)
            normalizedLocalizations.append(normalizedLanguage)
        }
        return normalizedLocalizations
    }

    static func normalize(localization: String) -> Language {
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
