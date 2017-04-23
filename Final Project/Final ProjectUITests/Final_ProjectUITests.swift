
//
//  Final_ProjectUITests.swift
//  Final ProjectUITests
//
//  Created by zimingg on 2/22/17.
//  Copyright © 2017 zimingg. All rights reserved.
//

import XCTest

class Final_ProjectUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        let logOutButton = XCUIApplication().buttons["Log out"]
        if logOutButton.exists {
            logOutButton.tap()
        }
        
        let textField = XCUIApplication().children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .textField).element
        textField.tap()
        textField.typeText("zimingg")
        
        let secureTextField = XCUIApplication().children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .secureTextField).element
        secureTextField.tap()
        secureTextField.typeText("Aa834362389!!")
        
        let app = XCUIApplication()
        app.buttons["login"].tap()
        
        let tabBarsQuery = app.tabBars
        tabBarsQuery.buttons["My Posts"].tap()
        
        
        
    
        
        let tablesQuery = app.tables
        tablesQuery.staticTexts["Effy's welcome party"].tap()
        
        let myPostButton = app.navigationBars["Final_Project.DetailView"].buttons["My Post"]
        myPostButton.tap()
        tablesQuery.staticTexts["Engineering Building"].tap()
        myPostButton.tap()
        tabBarsQuery.buttons["Me"].tap()
        tabBarsQuery.buttons["Map"].tap()
        app.buttons["Add"].tap()
        app.navigationBars["Add Event"].children(matching: .button).matching(identifier: "Back").element(boundBy: 0).tap()
        app.navigationBars["Final_Project.MapviewView"].buttons["Log out"].tap()
        
        
        
       
        
        
         }
    
}
