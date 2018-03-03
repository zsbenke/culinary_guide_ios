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
        if column == "region" && Localization.currentCountry == Localization.Country.CentralEurope {
            return #imageLiteral(resourceName: "Facet Country Europe")
        }

        if column == "region" && Localization.currentCountry == Localization.Country.Hungary {
            return #imageLiteral(resourceName: "Facet Country Hungary")
        }

        if column == "region" && Localization.currentCountry == Localization.Country.CzechRepublic {
            return #imageLiteral(resourceName: "Facet Country Czech Republic")
        }

        if column == "region" && Localization.currentCountry == Localization.Country.Slovakia {
            return #imageLiteral(resourceName: "Facet Country Slovakia")
        }

        if column == "region" && Localization.currentCountry == Localization.Country.Romania {
            return #imageLiteral(resourceName: "Facet Country Romania")
        }

        if column == "region" && Localization.currentCountry == Localization.Country.Serbia {
            return #imageLiteral(resourceName: "Facet Country Serbia")
        }

        if column == "region" && Localization.currentCountry == Localization.Country.Croatia {
            return #imageLiteral(resourceName: "Facet Country Croatia")
        }

        if column == "region" && Localization.currentCountry == Localization.Country.Slovenia {
            return #imageLiteral(resourceName: "Facet Country Slovenia")
        }

        if column == "city" || column == "region" {
            return #imageLiteral(resourceName: "Facet Pin")
        }

        if column == "title" {
            return #imageLiteral(resourceName: "Facet Menu Price")
        }
        
        if  ["open_on_sunday",
             "open_on_monday",
             "open_on_tuesday",
             "open_on_wednesday",
             "open_on_thursday",
             "open_on_friday",
             "open_on_saturday"].contains(column) {
            return #imageLiteral(resourceName: "Facet Open")
        }

        if ["def_people_one_name", "def_people_two_name", "def_people_three_name"].contains(column) {
            return #imageLiteral(resourceName: "Facet Chef")
        }

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

extension Array where Iterator.Element == RestaurantFacet? {
    func filter(homeScreenSection: RestaurantFacet.RestaurantHomeScreenSection) -> [RestaurantFacet?] {
        return filter { (facet) -> Bool in
            guard let facet = facet else { return false }
            return facet.homeScreenSection == homeScreenSection
        }
    }
}
