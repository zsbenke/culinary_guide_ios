import UIKit

struct RestaurantRating: Rating, Comparable {
    var points: String
    var color: UIColor {
        if isSecondary {
            return UIColor.BrandColor.secondaryRating
        }
        return UIColor.BrandColor.primaryRating
    }
    var image: UIImage {
        var image = UIImage()

        switch points {
        case "5":
            image = #imageLiteral(resourceName: "Rating 5")
        case "4":
            image = #imageLiteral(resourceName: "Rating 4")
        case "3":
            image = #imageLiteral(resourceName: "Rating 3")
        case "2":
            image = #imageLiteral(resourceName: "Rating 2")
        case "1":
            image = #imageLiteral(resourceName: "Rating 1")
        case "pop":
            image = #imageLiteral(resourceName: "Rating Pop")
        default:
            image = #imageLiteral(resourceName: "Rating Pop")
        }

        return image
    }
    var isSecondary: Bool {
        return points == "pop" || !["5", "4", "3", "2", "1"].contains(points)
    }

    static func < (lhs: RestaurantRating, rhs: RestaurantRating) -> Bool {
        let sortedPoints = ["pop", "1", "2", "3", "4", "5"]
        guard let lhsIndex = sortedPoints.index(of: lhs.points), let rhsIndex = sortedPoints.index(of: rhs.points) else { return false }
        return lhsIndex < rhsIndex
    }
}
