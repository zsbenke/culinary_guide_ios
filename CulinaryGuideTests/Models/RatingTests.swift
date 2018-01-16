//
//  RatingImageTests.swift
//  CulinaryGuideTests
//
//  Created by Benke Zsolt on 2018. 01. 16..
//  Copyright © 2018. Benke Zsolt. All rights reserved.
//

import XCTest

class RatingTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testImageWithTintColor() {
        let rating5 = Rating.init(rating: "5")
        XCTAssertTrue(rating5.image == #imageLiteral(resourceName: "Rating 5"))
        XCTAssertTrue(rating5.tintColor == UIColor.BrandColor.secondary)

        let rating4 = Rating.init(rating: "4")
        XCTAssertTrue(rating4.image == #imageLiteral(resourceName: "Rating 4"))
        XCTAssertTrue(rating4.tintColor == UIColor.BrandColor.secondary)

        let rating3 = Rating.init(rating: "3")
        XCTAssertTrue(rating3.image == #imageLiteral(resourceName: "Rating 3"))
        XCTAssertTrue(rating3.tintColor == UIColor.BrandColor.secondary)

        let rating2 = Rating.init(rating: "2")
        XCTAssertTrue(rating2.image == #imageLiteral(resourceName: "Rating 2"))
        XCTAssertTrue(rating2.tintColor == UIColor.BrandColor.secondary)

        let rating1 = Rating.init(rating: "1")
        XCTAssertTrue(rating1.image == #imageLiteral(resourceName: "Rating 1"))
        XCTAssertTrue(rating1.tintColor == UIColor.BrandColor.secondary)

        let ratingPop = Rating.init(rating: "pop")
        XCTAssertTrue(ratingPop.image == #imageLiteral(resourceName: "Rating Pop"))
        XCTAssertTrue(ratingPop.tintColor == UIColor.BrandColor.primary)

        let ratingRandom = Rating.init(rating: "random")
        XCTAssertTrue(ratingRandom.image == #imageLiteral(resourceName: "Rating Pop"))
        XCTAssertTrue(ratingRandom.tintColor == UIColor.BrandColor.primary)
    }
}
