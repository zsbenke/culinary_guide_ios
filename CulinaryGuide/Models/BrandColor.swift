import UIKit

extension UIColor {
    enum BrandColor {
        static var primary: UIColor {
            return UIColor(named: "Primary")!
        }
        
        static var primaryHighlighted: UIColor {
            return UIColor(named: "Primary Highlighted")!
        }
        
        static var secondary: UIColor {
            return UIColor(named: "Secondary")!
        }

        static var secondaryHighlighted: UIColor {
            return UIColor(named: "Secondary Highlighted")!
        }

        static var separator: UIColor {
            return UIColor(named: "Separator")!
        }

        static var linkText: UIColor {
            return UIColor(named: "Link Text")!
        }

        static var primaryRating: UIColor {
            return UIColor(named: "Primary Rating")!
        }

        static var primaryRatingHighlighted: UIColor {
            return UIColor(named: "Primary Rating Highlighted")!
        }

        static var secondaryRating: UIColor {
            return UIColor(named: "Secondary Rating")!
        }

        static var secondaryRatingHighlighted: UIColor {
            return UIColor(named: "Secondary Rating Highlighted")!
        }

        static var ratingFilterOff: UIColor {
            return UIColor(named: "Rating Filter Off")!
        }

        static var ratingFilterOffHighlighted: UIColor {
            return UIColor(named: "Rating Filter Off Highlighted")!
        }

        static var primaryRatingFilterOn: UIColor {
            return primaryRating
        }

        static var primaryRatingFilterOnHighlighted: UIColor {
            return primaryRatingHighlighted
        }

        static var secondaryRatingFilterOn: UIColor {
            return secondaryRating
        }

        static var secondaryRatingFilterOnHighlighted: UIColor {
            return secondaryHighlighted
        }

        static var windowBackground: UIColor {
            return UIColor(named: "Window Background")!
        }

        static var light: UIColor {
            return UIColor(named: "Light")!
        }

        static var lightHighlighted: UIColor {
            return UIColor(named: "Light Highlighted")!
        }

        static var facet: UIColor {
            return UIColor(named: "Facet")!
        }

        static var facetSelected: UIColor {
            return UIColor(named: "Facet Selected")!
        }

        static var facetText: UIColor {
            return primary
        }

        static var facetSeparator: UIColor {
            return separator
        }
    }

    // MARK: - Computed Properties

    var toHex: String? {
        return toHex()
    }

    // MARK: - From UIColor to String

    func toHex(alpha: Bool = false) -> String? {
        guard let components = cgColor.components, components.count >= 3 else {
            return nil
        }

        let r = Float(components[0])
        let g = Float(components[1])
        let b = Float(components[2])
        var a = Float(1.0)

        if components.count >= 4 {
            a = Float(components[3])
        }

        if alpha {
            return String(format: "%02lX%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255), lroundf(a * 255))
        } else {
            return String(format: "%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255))
        }
    }
}
