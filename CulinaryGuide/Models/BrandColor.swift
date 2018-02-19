import UIKit

extension UIColor {
    enum BrandColor {
        static var primary: UIColor {
            return UIColor(red: 0.00, green: 0.53, blue: 0.89, alpha: 1.0)
        }
        
        static var primaryHighlighted: UIColor {
            return UIColor(red: 0.00, green: 0.38, blue: 0.64, alpha: 1.00)
        }
        
        static var secondary: UIColor {
            return UIColor(red: 0.99, green: 0.81, blue: 0.04, alpha: 1.0)
        }

        static var secondaryHighlighted: UIColor {
            return UIColor(red: 0.82, green: 0.63, blue: 0.00, alpha: 1.00)
        }

        static var primarySplashScreen: UIColor {
            return UIColor(red: 0.00, green: 0.25, blue: 0.35, alpha: 1.0)
        }

        static var primarySplashScreenHighlighted: UIColor {
            return UIColor(red: 0.00, green: 0.17, blue: 0.23, alpha: 1.00)
        }

        static var primaryRating: UIColor {
            return secondary
        }

        static var primaryRatingHighlighted: UIColor {
            return secondaryHighlighted
        }

        static var secondaryRating: UIColor {
            return primary
        }

        static var secondaryRatingHighlighted: UIColor {
            return primaryHighlighted
        }

        static var ratingFilterOff: UIColor {
            return UIColor(red: 0.68, green: 0.74, blue :0.78, alpha: 1.0)
        }

        static var ratingFilterOffHighlighted: UIColor {
            return UIColor(red: 0.53, green: 0.58, blue: 0.61, alpha: 1.0)
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
            return secondaryRatingHighlighted
        }

        static var windowBackground: UIColor {
            return UIColor(red: 0.91, green: 0.94, blue: 0.95, alpha: 1.00)
        }

        static var light: UIColor {
            return .white
        }

        static var lightHighlighted: UIColor {
            return UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.75)
        }

        static var facet: UIColor {
            return UIColor(red: 0.91, green: 0.94, blue: 0.95, alpha: 1.0)
        }

        static var facetSelected: UIColor {
            return UIColor(red: 0.76, green: 0.78, blue: 0.79, alpha: 1.0)
        }

        static var facetText: UIColor {
            return UIColor(red: 0.00, green: 0.25, blue: 0.35, alpha: 1.0)
        }

        static var facetSeparator: UIColor {
            return UIColor(red: 0.00, green: 0.25, blue: 0.35, alpha: 0.5)
        }
    }
}
