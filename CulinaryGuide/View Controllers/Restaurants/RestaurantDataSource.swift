import UIKit

class RestaurantDataSource: NSObject {
    var restaurant: Restaurant
    var rows = [RestaurantRow]()

    private let detailTableViewCellNib = UINib(nibName: "DetailTableViewCell", bundle: .main)

    init(restaurant: Restaurant) {
        self.restaurant = restaurant
        super.init()

        appendToRows(column: .address, value: restaurant.address)
        appendToRows(column: .phone, value: restaurant.phone)
        appendToRows(column: .hours, value: restaurant.hours)
        appendToRows(column: .definingPeople, value: restaurant.definingPeople)
        appendToRows(column: .website, value: restaurant.website)
        appendToRows(column: .email, value: restaurant.email)
        appendToRows(column: .facebookPage, value: restaurant.facebookPage)
        appendToRows(column: .reservations, value: restaurant.reservations)
        appendToRows(column: .parking, value: restaurant.parking)
        appendToRows(column: .menuPrice, value: restaurant.menuPrice)
    }

    enum Column: String, EnumCollection {
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

    struct RestaurantRow {
        static var actionColumns: [Column] = [.website, .address, .phone, .email, .facebookPage]

        let column: Column
        let value: String
        var image: UIImage {
            return column.toImage()
        }
    }
}

extension RestaurantDataSource: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rows.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let restaurantRow = rows[indexPath.row]
        var cell = tableView.dequeueReusableCell(withIdentifier: "Detail Table Cell") as? DetailTableViewCell

        if cell != nil {
            tableView.register(detailTableViewCellNib, forCellReuseIdentifier: "Detail Table Cell")
            cell = tableView.dequeueReusableCell(withIdentifier: "Detail Table Cell") as? DetailTableViewCell
        }

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.15
        paragraphStyle.lineBreakMode = .byWordWrapping

        cell?.labelText.text = restaurantRow.column.rawValue
        cell?.iconImageView.image = restaurantRow.image
        cell?.valueText.attributedText = NSAttributedString(string: restaurantRow.value, attributes: [NSAttributedStringKey.paragraphStyle: paragraphStyle])

        if RestaurantRow.actionColumns.contains(restaurantRow.column) {
            cell?.valueText.textColor = UIColor.BrandColor.linkText
        }

        return cell!
    }
}

private extension RestaurantDataSource {
    func appendToRows(column: Column, value: CustomStringConvertible?) {
        if let value = value {
            var restaurantRow: RestaurantRow?

            if let newValue = (value as? URL)?.stringWithoutScheme() {
                restaurantRow = RestaurantRow(column: column, value: "\(newValue)")
            } else {
                restaurantRow = RestaurantRow(column: column, value: "\(value)")
            }

            guard let finalRestaurantRow = restaurantRow else { return }
            rows.append(finalRestaurantRow)
        }
    }
}
