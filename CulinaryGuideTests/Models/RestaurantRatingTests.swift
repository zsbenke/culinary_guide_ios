import XCTest

class RestaurantRatingTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testImageWithColor() {
        let rating5 = RestaurantRating.init(points: "5")
        XCTAssertEqual(rating5.image, #imageLiteral(resourceName: "Rating 5"))
        XCTAssertEqual(rating5.color, UIColor.BrandColor.primaryRating)
        
        let rating4 = RestaurantRating.init(points: "4")
        XCTAssertEqual(rating4.image, #imageLiteral(resourceName: "Rating 4"))
        XCTAssertEqual(rating4.color, UIColor.BrandColor.primaryRating)
        
        let rating3 = RestaurantRating.init(points: "3")
        XCTAssertEqual(rating3.image, #imageLiteral(resourceName: "Rating 3"))
        XCTAssertEqual(rating3.color, UIColor.BrandColor.primaryRating)
        
        let rating2 = RestaurantRating.init(points: "2")
        XCTAssertEqual(rating2.image, #imageLiteral(resourceName: "Rating 2"))
        XCTAssertEqual(rating2.color, UIColor.BrandColor.primaryRating)
        
        let rating1 = RestaurantRating.init(points: "1")
        XCTAssertEqual(rating1.image, #imageLiteral(resourceName: "Rating 1"))
        XCTAssertEqual(rating1.color, UIColor.BrandColor.primaryRating)
        
        let ratingPop = RestaurantRating.init(points: "pop")
        XCTAssertEqual(ratingPop.image, #imageLiteral(resourceName: "Rating Pop"))
        XCTAssertEqual(ratingPop.color, UIColor.BrandColor.secondaryRating)
        
        let ratingRandom = RestaurantRating.init(points: "random")
        XCTAssertEqual(ratingRandom.image, #imageLiteral(resourceName: "Rating Pop"))
        XCTAssertEqual(ratingRandom.color, UIColor.BrandColor.secondaryRating)
    }
}
