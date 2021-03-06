import UIKit

class RestaurantDataSource: NSObject {
    var restaurant: Restaurant
    var sections = Array(Section.cases())
    var detailRows = [DetailRow]()
    var reviews = [RestaurantReview]()

    private let detailTableViewCellNib = UINib(nibName: "DetailTableViewCell", bundle: .main)
    private var isDetailTableViewCellNibRegistered = false

    init(restaurant: Restaurant) {
        self.restaurant = restaurant
        super.init()

        appendToDetails(column: .address, value: restaurant.address)
        appendToDetails(column: .phone, value: restaurant.phone)
        appendToDetails(column: .hours, value: restaurant.hours)
        appendToDetails(column: .definingPeople, value: restaurant.definingPeople)
        appendToDetails(column: .website, value: restaurant.website)
        appendToDetails(column: .email, value: restaurant.email)
        appendToDetails(column: .facebookPage, value: restaurant.facebookPage)
        appendToDetails(column: .reservations, value: restaurant.reservations)
        appendToDetails(column: .parking, value: restaurant.parking)
        appendToDetails(column: .menuPrice, value: restaurant.menuPrice)
        appendToDetails(column: .creditCard, value: restaurant.creditCard)
        appendToDetails(column: .wifi, value: restaurant.wifi)

        for review in restaurant.reviews {
            reviews.append(review)
        }
    }

    enum DetailColumn: String, EnumCollection {
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
        case creditCard = "credit card"
        case wifi
        case review

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
            case .creditCard:
                return #imageLiteral(resourceName: "Facet Credit Card")
            case .wifi:
                return #imageLiteral(resourceName: "Facet Wi-Fi")
            default:
                return #imageLiteral(resourceName: "Facet Magnifiying Glass")
            }
        }

        func localized() -> String {
            switch self {
            case .address:
                return NSLocalizedString("Address", comment: "Adat címke az étterem nézeten.")
            case .phone:
                return NSLocalizedString("Phone", comment: "Adat címke az étterem nézeten.")
            case .hours:
                return NSLocalizedString("Hours", comment: "Adat címke az étterem nézeten.")
            case .definingPeople:
                return NSLocalizedString("People", comment: "Adat címke az étterem nézeten.")
            case .website:
                return NSLocalizedString("Website", comment: "Adat címke az étterem nézeten.")
            case .email:
                return NSLocalizedString("Email", comment: "Adat címke az étterem nézeten.")
            case .facebookPage:
                return NSLocalizedString("Facebook", comment: "Adat címke az étterem nézeten.")
            case .reservations:
                return NSLocalizedString("Reservation", comment: "Adat címke az étterem nézeten.")
            case .parking:
                return NSLocalizedString("Parking", comment: "Adat címke az étterem nézeten.")
            case .menuPrice:
                return NSLocalizedString("Menu Price", comment: "Adat címke az étterem nézeten.")
            case .review:
                return NSLocalizedString("Review", comment: "Adat címke az étterem nézeten.")
            case .title:
                return NSLocalizedString("Name", comment: "Adat címke az étterem nézeten.")
            case .creditCard:
                return NSLocalizedString("Credit Card", comment: "Adat címke az étterem nézeten.")
            case .wifi:
                return NSLocalizedString("Wi-Fi", comment: "Adat címke az étterem nézeten.")
            }
        }
    }

    struct DetailRow {
        static var actionColumns: [DetailColumn] = [.website, .address, .phone, .email, .facebookPage]

        let column: DetailColumn
        let value: String
        var image: UIImage {
            return column.toImage()
        }
    }

    enum Section: EnumCollection {
        case details
        case reviews
    }
}

extension RestaurantDataSource: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        var count = 0

        if !detailRows.isEmpty {
            count += 1
        }

        if !reviews.isEmpty {
            count += 1
        }

        return count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = getSection(for: section)

        switch section {
        case .details:
            return detailRows.count
        case .reviews:
            return reviews.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if !isDetailTableViewCellNibRegistered {
            tableView.register(detailTableViewCellNib, forCellReuseIdentifier: "Detail Table Cell")
            isDetailTableViewCellNibRegistered = true
        }

        var cell: UITableViewCell?
        let section = getSection(for: indexPath.section)

        if section == .reviews {
            cell = tableView.dequeueReusableCell(withIdentifier: "Review Table Cell")
            let restaurantReview = reviews[indexPath.row]
            configure(tableViewCell: cell, restaurantReview: restaurantReview)
        } else {
            cell = tableView.dequeueReusableCell(withIdentifier: "Detail Table Cell")
            let detailRow = detailRows[indexPath.row]
            configure(tableViewCell: cell as? DetailTableViewCell, detailRow: detailRow)
        }

        return cell!
    }

    func getSection(for sectionIndex: Int) -> Section {
        return sections[sectionIndex]
    }
}

private extension RestaurantDataSource {
    func appendToDetails(column: DetailColumn, value: CustomStringConvertible?) {

        if let value = value {
            var detailRow: DetailRow?

            if let newValue = (value as? URL)?.stringWithoutScheme() {
                detailRow = DetailRow(column: column, value: "\(newValue)")
            } else if let value = value as? String, !value.isEmpty {
                detailRow = DetailRow(column: column, value: "\(value)")
            }

            guard let finalDetailRow = detailRow else { return }
            detailRows.append(finalDetailRow)
        }
    }

    func configure(tableViewCell cell: DetailTableViewCell?, detailRow: DetailRow) {
        if DetailRow.actionColumns.contains(detailRow.column) {
            cell?.selectionStyle = .default
        } else {
            cell?.selectionStyle = .none
        }

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.15
        paragraphStyle.lineBreakMode = .byWordWrapping
        var attributedString = NSMutableAttributedString(string: detailRow.value, attributes: [NSAttributedStringKey.paragraphStyle: paragraphStyle])

        if detailRow.column == .menuPrice {
            let range = ("€€€€€" as NSString).range(of: detailRow.value)
            attributedString = NSMutableAttributedString(string: "€€€€€", attributes: [
                NSAttributedStringKey.paragraphStyle: paragraphStyle,
                NSAttributedStringKey.foregroundColor: UIColor.lightGray
            ])
            attributedString.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.black, range: range)
        } else if DetailRow.actionColumns.contains(detailRow.column) {
            let range = (detailRow.value as NSString).range(of: detailRow.value)
            attributedString.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.BrandColor.linkText, range: range)
        }

        cell?.labelText.text = detailRow.column.localized()
        cell?.iconImageView.image = detailRow.image
        cell?.valueText.attributedText = attributedString
    }

    func configure(tableViewCell cell: UITableViewCell?, restaurantReview: RestaurantReview) {
        if let text = restaurantReview.text {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineHeightMultiple = 1.15
            paragraphStyle.lineBreakMode = .byWordWrapping

            cell?.textLabel?.attributedText = NSAttributedString(string: text, attributes: [NSAttributedStringKey.paragraphStyle: paragraphStyle])
        }
    }
}
