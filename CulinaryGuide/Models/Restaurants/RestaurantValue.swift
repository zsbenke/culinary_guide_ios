import UIKit

struct RestaurantValue {
    enum RestaurantColumn: String, EnumCollection {
        case title
        case address
        case phone
        case hours = "hours"
        case definingPeople = "people"
        case website
        case email
        case facebookPage = "facebook"
        case reservations
        case parking
        case menuPrice = "menu price"

        func toImage() -> UIImage {
            switch self {
            case .address:
                return #imageLiteral(resourceName: "Facet Pin")
            case .phone:
                return #imageLiteral(resourceName: "Facet Phone")
            case .hours:
                return #imageLiteral(resourceName: "Facet Open")
            case .definingPeople:
                return #imageLiteral(resourceName: "Facet Chef")
            case .website:
                return #imageLiteral(resourceName: "Facet Website")
            case .email:
                return #imageLiteral(resourceName: "Facet Email")
            case .facebookPage:
                return #imageLiteral(resourceName: "Facet Facebook")
            case .reservations:
                return #imageLiteral(resourceName: "Facet Reservations")
            case .parking:
                return #imageLiteral(resourceName: "Facet Parking")
            case .menuPrice:
                return #imageLiteral(resourceName: "Facet Menu Price")
            default:
                return #imageLiteral(resourceName: "Facet Magnifiying Glass")
            }
        }
    }

    var image: UIImage {
        return column.toImage()
    }
    let column: RestaurantColumn
    let value: String
}

extension Restaurant {
    func values() -> [RestaurantValue] {
        var values = [RestaurantValue]()

        let appendValue: (CustomStringConvertible?, RestaurantValue.RestaurantColumn) -> Void = { value, column in
            if let value = value {
                var restaurantValue: RestaurantValue?

                if let newValue = (value as? URL)?.stringWithoutScheme() {
                    restaurantValue = RestaurantValue(column: column, value: "\(newValue)")
                } else {
                    restaurantValue = RestaurantValue(column: column, value: "\(value)")
                }

                if let finalRestaurantValue = restaurantValue {
                    values.append(finalRestaurantValue)
                }
            }
        }

        appendValue(address, .address)
        appendValue(phone, .phone)
        appendValue(hours, .hours)

        appendValue(definingPeople, .definingPeople)

        appendValue(website, .website)
        appendValue(email, .email)
        appendValue(facebookPage, .facebookPage)

        appendValue(reservations, .reservations)
        appendValue(parking, .parking)
        appendValue(menuPrice, .menuPrice)

        return values
    }
}
