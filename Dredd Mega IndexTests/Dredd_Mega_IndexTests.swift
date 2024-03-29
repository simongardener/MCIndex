//
//  Dredd_Mega_IndexTests.swift
//  Dredd Mega IndexTests
//
//  Created by Simon Gardener on 12/03/2019.
//  Copyright © 2019 Simon Gardener. All rights reserved.
//

import XCTest
import CoreData

@testable import Dredd_Mega_Index

class Dredd_Mega_IndexTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    func testShouldShowVolumeOwnership(){
        UserDefaults.setShowVolumeOwnership(to: true)
        XCTAssertTrue (UserDefaults.shouldShowVolumeOwnership())
    }
    
    func testShouldShowVolumeIsOwnedIsFalse(){
        UserDefaults.setShowVolumeOwnership(to: false)
        XCTAssertFalse(UserDefaults.shouldShowVolumeOwnership())
    }
    func testCountReturnsNumberOfEntityType() {
        let dataModel = DataModel()
        let count = dataModel.countEntity(Volume.self)
        XCTAssertEqual(count, 90)
    }
}
