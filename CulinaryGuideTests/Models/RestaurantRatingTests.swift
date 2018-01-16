//
//  RestaurantRatingImageTests.swift
//  CulinaryGuideTests
//
//  Created by Benke Zsolt on 2018. 01. 16..
//  Copyright © 2018. Benke Zsolt. All rights reserved.
//

import XCTest

class RestaurantRestaurantRatingTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testImageWithColor() {
        let rating5 = RestaurantRating.init(points: "5")
        XCTAssertTrue(rating5.image == #imageLiteral(resourceName: "Rating 5"))
        XCTAssertTrue(rating5.color == UIColor.BrandColor.secondary)

        let rating4 = RestaurantRating.init(points: "4")
        XCTAssertTrue(rating4.image == #imageLiteral(resourceName: "Rating 4"))
        XCTAssertTrue(rating4.color == UIColor.BrandColor.secondary)

        let rating3 = RestaurantRating.init(points: "3")
        XCTAssertTrue(rating3.image == #imageLiteral(resourceName: "Rating 3"))
        XCTAssertTrue(rating3.color == UIColor.BrandColor.secondary)

        let rating2 = RestaurantRating.init(points: "2")
        XCTAssertTrue(rating2.image == #imageLiteral(resourceName: "Rating 2"))
        XCTAssertTrue(rating2.color == UIColor.BrandColor.secondary)

        let rating1 = RestaurantRating.init(points: "1")
        XCTAssertTrue(rating1.image == #imageLiteral(resourceName: "Rating 1"))
        XCTAssertTrue(rating1.color == UIColor.BrandColor.secondary)

        let ratingPop = RestaurantRating.init(points: "pop")
        XCTAssertTrue(ratingPop.image == #imageLiteral(resourceName: "Rating Pop"))
        XCTAssertTrue(ratingPop.color == UIColor.BrandColor.primary)

        let ratingRandom = RestaurantRating.init(points: "random")
        XCTAssertTrue(ratingRandom.image == #imageLiteral(resourceName: "Rating Pop"))
        XCTAssertTrue(ratingRandom.color == UIColor.BrandColor.primary)
    }
}
