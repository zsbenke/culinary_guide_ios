import UIKit

extension UIImage {
    class func imageWithColor(color:UIColor?) -> UIImage! {
        let rect = CGRect.init(x: 0, y: 0, width: 1.0, height: 1.0)

        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)

        let context = UIGraphicsGetCurrentContext()

        if let color = color {
            color.setFill()
        } else {
            UIColor.white.setFill()
        }

        if let context = context {
            context.fill(rect)
        }

        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return image
    }
}
