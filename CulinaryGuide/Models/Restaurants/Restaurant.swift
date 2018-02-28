import Foundation
import MapKit
import CoreSpotlight
import MobileCoreServices

struct Restaurant: PointOfInterest, Codable {
    let id: Int?
    let title: String?
    let year: String?
    let address: String?
    let latitude: String?
    let longitude: String?
    let rating: String?
    let phone: String?
    let openResults: String?
    let website: URL?
    let facebookPage: URL?
    let reservations: String?
    let parking: String?

    var uniqueIdentifier: String? {
        guard let id = id  else { return nil }
        return "\(id)"
    }

    private let menuPriceInformation: String?
    private let menuPriceRating: Int?
    private let rawEmail: String?
    private let firstDefiningPersonName: String?
    private let firstDefiningPersonTitle: String?
    private let secondDefiningPersonName: String?
    private let secondDefiningPersonTitle: String?
    private let thirdDefiningPersonName: String?
    private let thirdDefiningPersonTitle: String?

    var firstDefiningPerson: Person? {
        guard let firstDefiningPersonName = firstDefiningPersonName,
              let firstDefiningPersonTitle = firstDefiningPersonTitle else {
                return nil
        }

        if firstDefiningPersonName.isEmpty || firstDefiningPersonName == "--" { return nil }
        if firstDefiningPersonTitle.isEmpty || firstDefiningPersonTitle == "--" { return nil }

        return Person(name: firstDefiningPersonName, title: firstDefiningPersonTitle)
    }

    var secondDefiningPerson: Person? {
        guard let secondDefiningPersonName = secondDefiningPersonName,
              let secondDefiningPersonTitle = secondDefiningPersonTitle else {
                return nil
        }

        if secondDefiningPersonName.isEmpty || secondDefiningPersonName == "--" { return nil }
        if secondDefiningPersonTitle.isEmpty || secondDefiningPersonTitle == "--" { return nil }

        return Person(name: secondDefiningPersonName, title: secondDefiningPersonTitle)
    }

    var thirdDefiningPerson: Person? {
        guard let thirdDefiningPersonName = thirdDefiningPersonName,
              let thirdDefiningPersonTitle = thirdDefiningPersonTitle else {
                return nil
        }

        if thirdDefiningPersonName.isEmpty || thirdDefiningPersonName == "--" { return nil }
        if thirdDefiningPersonTitle.isEmpty || thirdDefiningPersonTitle == "--" { return nil }
        
        return Person(name: thirdDefiningPersonName, title: thirdDefiningPersonTitle)
    }

    var email: Email? {
        guard let rawEmail = rawEmail else { return nil }
        return Email(string: rawEmail)
    }

    var menuPrice: String? {
        guard let menuPriceRating = menuPriceRating else {
            return nil
        }

        var menuPriceRatingLabel = ""

        switch menuPriceRating {
        case 1:
            menuPriceRatingLabel = "€"
        case 2:
            menuPriceRatingLabel = "€€"
        case 3:
            menuPriceRatingLabel = "€€€"
        case 4:
            menuPriceRatingLabel = "€€€€"
        case 5:
            menuPriceRatingLabel = "€€€€€"
        default:
            menuPriceRatingLabel = ""
        }

        return menuPriceRatingLabel
    }

    struct Person: CustomStringConvertible {
        let name: String
        let title: String

        var description: String {
            return "\(name) – \(title)"
        }
    }

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case year
        case address = "full_address"
        case latitude
        case longitude
        case rating = "rating"
        case phone = "phone_1"
        case openResults = "open_results"
        case website
        case facebookPage = "facebook"
        case firstDefiningPersonName = "def_people_one_name"
        case firstDefiningPersonTitle = "def_people_one_title"
        case secondDefiningPersonName = "def_people_two_name"
        case secondDefiningPersonTitle = "def_people_two_title"
        case thirdDefiningPersonName = "def_people_three_name"
        case thirdDefiningPersonTitle = "def_people_three_title"
        case rawEmail = "email"
        case reservations = "reservation_needed"
        case parking = "has_parking"
        case menuPriceInformation = "price_information"
        case menuPriceRating = "price_information_rating"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        do {
            id = try container.decode(Int.self, forKey: .id)
        } catch {
            id = nil
        }

        do {
            title = try container.decode(String.self, forKey: .title)
        } catch {
            title = nil
        }

        do {
            year = try container.decode(String.self, forKey: .year)
        } catch {
            year = nil
        }

        do {
            address = try container.decode(String.self, forKey: .address)
        } catch {
            address = nil
        }

        do {
            latitude = try container.decode(String.self, forKey: .latitude)
        } catch {
            latitude = nil
        }

        do {
            longitude = try container.decode(String.self, forKey: .longitude)
        } catch {
            longitude = nil
        }

        do {
            rating = try container.decode(String.self, forKey: .rating)
        } catch {
            rating = nil
        }

        do {
            phone = try container.decode(String.self, forKey: .phone)
        } catch {
            phone = nil
        }

        do {
            openResults = try container.decode(String.self, forKey: .openResults)
        } catch {
            openResults = nil
        }

        do {
            let rawURL = try container.decode(URL.self, forKey: .website)
            if rawURL.absoluteString.hasPrefix("http://") || rawURL.absoluteString.hasPrefix("https://") {
                website = rawURL
            } else {
                website = URL(string: "http://\(rawURL)")
            }
        } catch {
            website = nil
        }

        do {
            let rawURL = try container.decode(URL.self, forKey: .facebookPage)
            if rawURL.absoluteString.hasPrefix("http://") || rawURL.absoluteString.hasPrefix("https://") {
                facebookPage = rawURL
            } else {
                facebookPage = URL(string: "http://\(rawURL)")
            }
        } catch {
            facebookPage = nil
        }

        do {
            rawEmail = try container.decode(String.self, forKey: .rawEmail)
        } catch {
            rawEmail = nil
        }

        do {
            menuPriceRating = try container.decode(Int.self, forKey: .menuPriceRating)
        } catch {
            menuPriceRating = nil
        }

        do {
            menuPriceInformation = try container.decode(String.self, forKey: .menuPriceInformation)
        } catch {
            menuPriceInformation = nil
        }

        do {
            parking = try container.decode(String.self, forKey: .parking)
        } catch {
            parking = nil
        }

        do {
            reservations = try container.decode(String.self, forKey: .reservations)
        } catch {
            reservations = nil
        }

        do {
            firstDefiningPersonName = try container.decode(String.self, forKey: .firstDefiningPersonName)
        } catch {
            firstDefiningPersonName = nil
        }

        do {
            firstDefiningPersonTitle = try container.decode(String.self, forKey: .firstDefiningPersonTitle)
        } catch {
            firstDefiningPersonTitle = nil
        }

        do {
            secondDefiningPersonName = try container.decode(String.self, forKey: .secondDefiningPersonName)
        } catch {
            secondDefiningPersonName = nil
        }

        do {
            secondDefiningPersonTitle = try container.decode(String.self, forKey: .secondDefiningPersonTitle)
        } catch {
            secondDefiningPersonTitle = nil
        }

        do {
            thirdDefiningPersonName = try container.decode(String.self, forKey: .thirdDefiningPersonName)
        } catch {
            thirdDefiningPersonName = nil
        }

        do {
            thirdDefiningPersonTitle = try container.decode(String.self, forKey: .thirdDefiningPersonTitle)
        } catch {
            thirdDefiningPersonTitle = nil
        }
    }

    func toAnnotation() -> RestaurantAnnotation? {
        guard let title = title else { return nil }
        guard let address = address else { return nil }
        guard let coordinate = calculateCoordinate() else { return nil }
        return RestaurantAnnotation.init(title: title, locationName: title, discipline: address, coordinate: coordinate)
    }

    func calculateCoordinate() -> CLLocationCoordinate2D? {
        guard let latitude = latitude else { return nil }
        guard let longitude = longitude else { return nil }

        let locationLatitude = Double(latitude)
        let locationLongitude = Double(longitude)

        guard let lat = locationLatitude, let long = locationLongitude else { return nil }

        return CLLocationCoordinate2D(latitude: lat, longitude: long)
    }

    static func indexItems() {
        let lastIndexedKey = "lastIndexedTimeIntervalFor\(Localization.currentCountry)"
        let indexingInterval = Double(604800) // egy hét unix timestampben
        let currentTime = Double(Date().timeIntervalSince1970)

        let indexSearchableItems: () -> Void = {
            var searchableItems = [CSSearchableItem]()

            self.index(completionHandler: { restaurants in
                for restaurant in restaurants {
                    guard let restaurant = restaurant else { continue }
                    let searchableItemAttributeSet = CSSearchableItemAttributeSet(itemContentType: kUTTypeText as String)
                    searchableItemAttributeSet.title = restaurant.title
                    searchableItemAttributeSet.contentDescription = restaurant.address

                    if let phone = restaurant.phone { searchableItemAttributeSet.phoneNumbers = [phone] }
                    if let coordinate = restaurant.calculateCoordinate() {
                        searchableItemAttributeSet.latitude = NSNumber(value: Double(coordinate.latitude))
                        searchableItemAttributeSet.longitude = NSNumber(value: Double(coordinate.longitude))
                        searchableItemAttributeSet.supportsNavigation = true
                    }

                    let searchableItem = CSSearchableItem(uniqueIdentifier: restaurant.uniqueIdentifier, domainIdentifier: "restaurants", attributeSet: searchableItemAttributeSet)
                    searchableItems.append(searchableItem)
                }

                CSSearchableIndex.default().indexSearchableItems(searchableItems) { (error) in
                    if error == nil {
                        print("indexed \(searchableItems.count) restaurants for \(Localization.currentCountry) at \(currentTime)")
                    }
                }

                UserDefaults.standard.set(currentTime, forKey: lastIndexedKey)
            })
        }

        guard let lastIndexed = UserDefaults.standard.value(forKey: lastIndexedKey) as? Double else {
            indexSearchableItems()
            return
        }
        guard currentTime - indexingInterval > lastIndexed else { return }

        indexSearchableItems()
    }
}

extension Restaurant {
    struct RestaurantValue {
        enum RestaurantValueSection: EnumCollection {
            case hero
            case contact
            case people
            case websites
            case information
            case features
        }

        enum RestaurantColumn: String, EnumCollection {
            case title
            case address
            case phone
            case openResults
            case firstDefiningPerson
            case secondDefiningPerson
            case thirdDefiningPerson
            case website
            case email
            case facebookPage
            case reservations
            case parking
            case menuPrice

            func toImage() -> UIImage {
                switch self {
                case .address:
                    return #imageLiteral(resourceName: "Facet Pin")
                case .phone:
                    return #imageLiteral(resourceName: "Facet Phone")
                case .openResults:
                    return #imageLiteral(resourceName: "Facet Open")
                case .firstDefiningPerson, .secondDefiningPerson, .thirdDefiningPerson:
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
        let section: RestaurantValueSection
    }

    func toDataSource() -> [RestaurantValue] {
        var values = [RestaurantValue]()

        let appendValue: (CustomStringConvertible?, RestaurantValue.RestaurantColumn, RestaurantValue.RestaurantValueSection) -> Void = { value, column, section in
            if let value = value {
                var restaurantValue: RestaurantValue?

                if let newValue = (value as? URL)?.stringWithoutScheme() {
                    restaurantValue = RestaurantValue(column: column, value: "\(newValue)", section: section)
                } else {
                    restaurantValue = RestaurantValue(column: column, value: "\(value)", section: section)
                }

                if let finalRestaurantValue = restaurantValue {
                    values.append(finalRestaurantValue)
                }
            }
        }

        appendValue(self.address, .address, .contact)
        appendValue(self.phone, .phone, .contact)
        appendValue(self.openResults, .openResults, .contact)

        appendValue(self.firstDefiningPerson, .firstDefiningPerson, .people)
        appendValue(self.secondDefiningPerson, .secondDefiningPerson, .people)
        appendValue(self.thirdDefiningPerson, .thirdDefiningPerson, .people)

        appendValue(self.website, .website, .websites)
        appendValue(self.email, .email, .websites)
        appendValue(self.facebookPage, .facebookPage, .websites)

        appendValue(self.reservations, .reservations, .information)
        appendValue(self.parking, .parking, .information)
        appendValue(self.menuPrice, .menuPrice, .information)

        return values
    }
}

extension Restaurant: APIResource {
    internal static let router = RestaurantRouter.self

    static func index(completionHandler: @escaping (_ restaurants: [Restaurant?]) -> Void) {
        let operationQueue = OperationQueue()
        let requestOperation = APIRequestOperation(urlRequest: router.index.asURLRequest())
        requestOperation.completionBlock = {
            guard let data = requestOperation.data else { return }
            do {
                let restaurants = try JSONDecoder().decode([Restaurant].self, from: data)
                completionHandler(restaurants)
            } catch {
                return
            }
        }
        operationQueue.addOperation(requestOperation)
    }

    static func index(search tokens: [URLQueryToken], completionHandler: @escaping (_ restaurants: [Restaurant?]) -> Void) {
        let operationQueue = OperationQueue()
        let requestOperation = APIRequestOperation(urlRequest: router.search(tokens).asURLRequest())
        requestOperation.completionBlock = {
            guard let data = requestOperation.data else { return }
            do {
                let restaurants = try JSONDecoder().decode([Restaurant].self, from: data)
                completionHandler(restaurants)
            } catch {
                return
            }
        }
        operationQueue.addOperation(requestOperation)
    }

    static func show(_ id: Int, completionHandler: @escaping (_ restaurant: Restaurant?) -> Void) {
        let operationQueue = OperationQueue()
        let requestOperation = APIRequestOperation(urlRequest: router.show(id).asURLRequest())
        requestOperation.completionBlock = {
            guard let data = requestOperation.data else { return }
            do {
                let restaurant = try JSONDecoder().decode(Restaurant.self, from: data)
                completionHandler(restaurant)
            } catch {
                return
            }

        }
        operationQueue.addOperation(requestOperation)
    }

    static func facets(completionHandler: @escaping (_ restaurantFacets: [RestaurantFacet?]) -> Void) {
        let operationQueue = OperationQueue()
        let requestOperation = APIRequestOperation(urlRequest: router.facetIndex.asURLRequest())
        requestOperation.completionBlock = {
            guard let data = requestOperation.data else { return }
            do {
                let restaurantFacets = try JSONDecoder().decode([RestaurantFacet].self, from: data)
                completionHandler(restaurantFacets)
            } catch {
                return
            }
        }
        operationQueue.addOperation(requestOperation)
    }

    static func facets(search query: String, completionHandler: @escaping (_ restaurantFacets: [RestaurantFacet?]) -> Void) {
        let operationQueue = OperationQueue()
        let requestOperation = APIRequestOperation(urlRequest: router.facetSearch(query).asURLRequest())
        requestOperation.completionBlock = {
            guard let data = requestOperation.data else { return }
            do {
                let restaurantFacets = try JSONDecoder().decode([RestaurantFacet].self, from: data)
                completionHandler(restaurantFacets)
            } catch {
                return
            }
        }
        operationQueue.addOperation(requestOperation)
    }
}
