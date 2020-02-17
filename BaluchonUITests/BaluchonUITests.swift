//
//  BaluchonUITests.swift
//  BaluchonUITests
//
//  Created by Fabrice Etiennette on 16/02/2020.
//  Copyright © 2020 Fabrice Etiennette. All rights reserved.
//

import XCTest

class BaluchonUITests: XCTestCase {

    let app = XCUIApplication()

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        XCUIApplication().launch()
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
        app.tabBars.buttons["Translate"].tap()
        app.tabBars.buttons["Today"].tap()
        app.tabBars.buttons["Weather"].tap()
        app.tabBars.buttons["Currency"].tap()
    }
}
