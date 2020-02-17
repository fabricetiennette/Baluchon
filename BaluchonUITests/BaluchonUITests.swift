//
//  BaluchonUITests.swift
//  BaluchonUITests
//
//  Created by Fabrice Etiennette on 16/02/2020.
//  Copyright © 2020 Fabrice Etiennette. All rights reserved.
//

import XCTest

class BaluchonUITests: XCTestCase {

    var app: XCUIApplication!

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
        sleep(1)
        addUIInterruptionMonitor(withDescription: "System Dialog") { (alert) -> Bool in
            // Tap "Allow" button
            let allowButton = alert.buttons["Allow"]
            if allowButton.exists {
                allowButton.tap()
            }

            let locationButton = alert.buttons["Allow While Using App"]
            if locationButton.exists {
                locationButton.tap()
            }
            return true
        }
    }

    override func tearDown() {
        super.tearDown()
    }

    func testTabBar() {
        app.tabBars.buttons["Translate"].tap(wait: 10, test: self)
        app.tabBars.buttons["Today"].tap(wait: 10, test: self)
        app.tabBars.buttons["Weather"].tap(wait: 10, test: self)
        app.tabBars.buttons["Currency"].tap(wait: 10, test: self)
    }
}

extension XCUIElement {
    func tap(wait: Int, test: XCTestCase) {
        if !isHittable {
            test.expectation(for: NSPredicate(format: "hittable == true"), evaluatedWith: self, handler: nil)
            test.waitForExpectations(timeout: TimeInterval(wait), handler: nil)
        }
        tap()
    }
}
