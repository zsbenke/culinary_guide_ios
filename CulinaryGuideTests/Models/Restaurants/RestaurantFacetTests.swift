import XCTest

class RestaurantFacetTests: XCTestCase {
    func testJSONDecoder() {
        let jsonData = "{ \"id\": 1, \"column\": \"tag\", \"value\": \"test\", \"locale\": \"hu\", \"country\": \"hu\", \"home_screen_section\": \"what\" }".data(using: .utf8)

        do {
            let facet = try JSONDecoder().decode(RestaurantFacet.self, from: jsonData!)

            XCTAssertEqual(facet.value, "test")
            XCTAssertEqual(facet.column, "tag")
            XCTAssertEqual(facet.homeScreenSection, .what)
            XCTAssertEqual(facet.icon, #imageLiteral(resourceName: "Facet Magnifiying Glass"))
        } catch {
            XCTFail("couldn't decode JSON data")
        }

        let jsonDataWithEmptyHomeScreenValue = "{ \"id\": 1, \"column\": \"tag\", \"value\": \"test\", \"locale\": \"hu\", \"country\": \"hu\", \"home_screen_section\":\" \" }".data(using: .utf8)

        do {
            let facet = try JSONDecoder().decode(RestaurantFacet.self, from: jsonDataWithEmptyHomeScreenValue!)

            XCTAssertEqual(facet.value, "test")
            XCTAssertEqual(facet.column, "tag")
            XCTAssertEqual(facet.homeScreenSection, .none)
            XCTAssertEqual(facet.icon, #imageLiteral(resourceName: "Facet Magnifiying Glass"))
        } catch {
            XCTFail("couldn't decode JSON data")
        }

        let jsonDataWithCorruptHomeScreenValue = "{ \"id\": 1, \"column\": \"tag\", \"value\": \"test\", \"locale\": \"hu\", \"country\": \"hu\", \"home_screen_section\":\"c0rrupt d4t4\" }".data(using: .utf8)

        do {
            let facet = try JSONDecoder().decode(RestaurantFacet.self, from: jsonDataWithCorruptHomeScreenValue!)

            XCTAssertEqual(facet.value, "test")
            XCTAssertEqual(facet.column, "tag")
            XCTAssertEqual(facet.homeScreenSection, .none)
            XCTAssertEqual(facet.icon, #imageLiteral(resourceName: "Facet Magnifiying Glass"))
        } catch {
            XCTFail("couldn't decode JSON data")
        }

        let jsonDataWithMissingHomeScreenValue = "{ \"id\": 1, \"column\": \"tag\", \"value\": \"test\", \"locale\": \"hu\", \"country\": \"hu\" }".data(using: .utf8)

        do {
            let facet = try JSONDecoder().decode(RestaurantFacet.self, from: jsonDataWithMissingHomeScreenValue!)

            XCTAssertEqual(facet.value, "test")
            XCTAssertEqual(facet.column, "tag")
            XCTAssertEqual(facet.homeScreenSection, .none)
            XCTAssertEqual(facet.icon, #imageLiteral(resourceName: "Facet Magnifiying Glass"))
        } catch {
            XCTFail("couldn't decode JSON data")
        }
    }
}
