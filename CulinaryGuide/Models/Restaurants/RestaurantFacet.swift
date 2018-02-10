import UIKit

struct RestaurantFacet: Facet, Codable {
    enum RestaurantHomeScreenSection: String, HomeScreenSection, Codable {
        case what = "what"
        case when = "when"
        case `where` = "where"
        case none

        var description: String {
            return rawValue
        }
    }

    var column: String?
    var value: String?
    var icon: UIImage? {
        // TODO: setup custom icons based on the column property
        return #imageLiteral(resourceName: "Facet Magnifiying Glass")
    }
    var homeScreenSection: RestaurantHomeScreenSection {
        guard let homeScreenSectionRawValue = homeScreenSectionRawValue else {
            return RestaurantHomeScreenSection.none
        }
        guard let section = RestaurantHomeScreenSection.init(rawValue: homeScreenSectionRawValue) else {
            return RestaurantHomeScreenSection.none
        }
        return section
    }

    private var homeScreenSectionRawValue: String?

    enum CodingKeys: String, CodingKey {
        case column
        case value
        case homeScreenSectionRawValue = "home_screen_section"
    }
}
