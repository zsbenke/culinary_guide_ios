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
            default:
                return #imageLiteral(resourceName: "Facet Magnifiying Glass")
            }
        }

        func localized() -> String {
            switch self {
            case .address:
                return NSLocalizedString("cím", comment: "Adat címke az étterem nézeten.")
            case .phone:
                return NSLocalizedString("telefon", comment: "Adat címke az étterem nézeten.")
            case .hours:
                return NSLocalizedString("nyitvatartás", comment: "Adat címke az étterem nézeten.")
            case .definingPeople:
                return NSLocalizedString("kapcsolódó személyek", comment: "Adat címke az étterem nézeten.")
            case .website:
                return NSLocalizedString("webhely", comment: "Adat címke az étterem nézeten.")
            case .email:
                return NSLocalizedString("e-mail", comment: "Adat címke az étterem nézeten.")
            case .facebookPage:
                return NSLocalizedString("facebook", comment: "Adat címke az étterem nézeten.")
            case .reservations:
                return NSLocalizedString("foglalás", comment: "Adat címke az étterem nézeten.")
            case .parking:
                return NSLocalizedString("parkolás", comment: "Adat címke az étterem nézeten.")
            case .menuPrice:
                return NSLocalizedString("menü ára", comment: "Adat címke az étterem nézeten.")
            case .review:
                return NSLocalizedString("teszt", comment: "Adat címke az étterem nézeten.")
            case .title:
                return NSLocalizedString("neve", comment: "Adat címke az étterem nézeten.")
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
            } else {
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

        cell?.labelText.text = detailRow.column.localized()
        cell?.iconImageView.image = detailRow.image
        cell?.valueText.attributedText = NSAttributedString(string: detailRow.value, attributes: [NSAttributedStringKey.paragraphStyle: paragraphStyle])

        if DetailRow.actionColumns.contains(detailRow.column) {
            cell?.valueText.textColor = UIColor.BrandColor.linkText
        }
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
