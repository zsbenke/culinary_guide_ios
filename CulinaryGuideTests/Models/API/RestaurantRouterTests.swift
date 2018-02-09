import XCTest

class RestaurantRouterTests: XCTestCase {
    func testBaseURLEndpoint() {
        let baseURLEndpoint = "\(API.baseURL)/restaurants"
        XCTAssert(baseURLEndpoint == RestaurantRouter.baseURLEndpoint)
    }

    func testAsURLRequest() {
        let assertedIndexURL = URL(string: "\(RestaurantRouter.baseURLEndpoint)/?country=\(Localization.currentCountry)&locale=\(Localization.currentLocale)")!
        let assertedIndexURLRequest = URLRequest(url: assertedIndexURL)
        let indexURLRequest = RestaurantRouter.index.asURLRequest()
        XCTAssertEqual(assertedIndexURLRequest, indexURLRequest)

        let assertedSearchURL = URL(string: "\(RestaurantRouter.baseURLEndpoint)/?tokens%5B%5D%5Bcolumn%5D=search&tokens%5B%5D%5Bvalue%5D=test&country=\(Localization.currentCountry)&locale=\(Localization.currentLocale)")!
        let assertedSearchURLRequest = URLRequest(url: assertedSearchURL)
        let searchURLRequest = RestaurantRouter.search([URLQueryToken(column: "search", value: "test")]).asURLRequest()
        XCTAssertEqual(assertedSearchURLRequest, searchURLRequest)

        let assertedShowURL = URL(string: "\(RestaurantRouter.baseURLEndpoint)/1234?country=\(Localization.currentCountry)&locale=\(Localization.currentLocale)")!
        let assertedShowURLRequest = URLRequest(url: assertedShowURL)
        let showURLRequest = RestaurantRouter.show(1234).asURLRequest()
        XCTAssertEqual(assertedShowURLRequest, showURLRequest)

        let assertedFacetIndexURL = URL(string: "\(RestaurantRouter.baseURLEndpoint)/autocomplete?country=\(Localization.currentCountry)&locale=\(Localization.currentLocale)")!
        let assertedFacetIndexURLRequest = URLRequest(url: assertedFacetIndexURL)
        let facetIndexURLRequest = RestaurantRouter.facetIndex.asURLRequest()
        XCTAssertEqual(assertedFacetIndexURLRequest, facetIndexURLRequest)

        let assertedFacetSearchURL = URL(string: "\(RestaurantRouter.baseURLEndpoint)/autocomplete?search=test&country=\(Localization.currentCountry)&locale=\(Localization.currentLocale)")!
        let assertedFacetSearchURLRequest = URLRequest(url: assertedFacetSearchURL)
        let facetSearchURLRequest = RestaurantRouter.facetSearch("test").asURLRequest()
        XCTAssertEqual(assertedFacetSearchURLRequest, facetSearchURLRequest)
    }
}
