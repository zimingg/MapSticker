//
//  Final_ProjectTests.swift
//  Final ProjectTests
//
//  Created by zimingg on 2/22/17.
//  Copyright © 2017 zimingg. All rights reserved.
//

import XCTest
@testable import Final_Project

class Final_ProjectTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func DatabaseControllerTest() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let controller = DatabaseController.self
        XCTAssertEqual(controller.persistentContainer.managedObjectModel.entities.count, 3, "number of entities is wrong.")
        
        XCTAssertEqual(controller.persistentContainer.managedObjectModel.entities(forConfigurationName: "MapPin")?.count, controller.persistentContainer.managedObjectModel.entities(forConfigurationName: "Events")?.count,"MapPin not equal to Events")
        
        
        
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
