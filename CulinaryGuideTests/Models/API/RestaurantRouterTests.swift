import XCTest

class RestaurantRouterTests: XCTestCase {
    func testbaseURLEndpoint() {
        let baseURLEndpoint = "\(API.baseURL)/restaurants"
        XCTAssert(baseURLEndpoint == RestaurantRouter.baseURLEndpoint)
    }

    func testAsURLRequest() {
        let assertedIndexURL = URL(string: "\(RestaurantRouter.baseURLEndpoint)/?country=\(Localization.currentCountry)&locale=\(Localization.currentLocale)")!
        let assertedIndexURLRequest = URLRequest(url: assertedIndexURL)
        let indexURLRequest = RestaurantRouter.index.asURLRequest()
        let searchURLRequest = RestaurantRouter.index.asURLRequest()
        XCTAssertEqual(assertedIndexURLRequest, indexURLRequest)
        XCTAssertEqual(assertedIndexURLRequest, searchURLRequest)

        let assertedShowURL = URL(string: "\(RestaurantRouter.baseURLEndpoint)/1234?country=\(Localization.currentCountry)&locale=\(Localization.currentLocale)")!
        let assertedShowURLRequest = URLRequest(url: assertedShowURL)
        let showURLRequest = RestaurantRouter.show(1234).asURLRequest()
        XCTAssertEqual(assertedShowURLRequest, showURLRequest)
    }
}
