import UIKit

extension UIColor {
    enum BrandColor {
        static var primary: UIColor {
            return UIColor(red: 0.89, green: 0.25, blue: 0.00, alpha: 1.00)
        }
        
        static var primaryHighlighted: UIColor {
            return UIColor(red: 0.51, green: 0.15, blue: 0.00, alpha: 1.00)
        }
        
        static var secondary: UIColor {
            return UIColor(red: 0.02, green: 0.60, blue: 0.86, alpha: 1.00)
        }

        static var secondaryHighlighted: UIColor {
            return UIColor(red: 0.01, green: 0.43, blue: 0.61, alpha: 1.00)
        }

        static var primaryRating: UIColor {
            return primary
        }

        static var primaryRatingHighlighted: UIColor {
            return primaryHighlighted
        }

        static var secondaryRating: UIColor {
            return secondary
        }

        static var secondaryRatingHighlighted: UIColor {
            return secondaryHighlighted
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
    }
}
