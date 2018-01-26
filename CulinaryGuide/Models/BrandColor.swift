import UIKit

extension UIColor {
    enum BrandColor {
        static var primary: UIColor {
            return UIColor(red: 0.75, green: 0.15, blue: 0.18, alpha: 1.0)
        }
        
        static var primaryHighlighted: UIColor {
            return UIColor(red: 0.54, green: 0.11, blue: 0.13, alpha: 1.0)
        }
        
        static var secondary: UIColor {
            return UIColor(red: 0.95, green: 0.71, blue: 0.00, alpha: 1.0)
        }
        
        static var light: UIColor {
            return UIColor.white
        }
        
        static var lightHighlighted: UIColor {
            return UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.75)
        }

        static var ratingFilterOff: UIColor {
            return UIColor(red: 0.68, green: 0.74, blue :0.78, alpha: 1.0)
        }

        static var ratingFilterOffHighlighted: UIColor {
            return UIColor(red: 0.53, green: 0.58, blue: 0.61, alpha: 1.0)
        }

        static var ratingFilterOn: UIColor {
            return self.primary
        }

        static var ratingFilterOnHighlighted: UIColor {
            return self.primary
        }
    }
}
