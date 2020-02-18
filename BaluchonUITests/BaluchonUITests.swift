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
        app.tabBars.buttons["Translate"].forceTapElement()
        app.tabBars.buttons["Today"].forceTapElement()
        app.tabBars.buttons["Weather"].forceTapElement()
        app.tabBars.buttons["Currency"].forceTapElement()
    }
}

extension XCUIElement {
    func forceTapElement() {
        if self.isHittable {
            self.tap()
        } else {
            let coordinate: XCUICoordinate = self.coordinate(withNormalizedOffset: CGVector(dx: 0.0, dy: 0.0))
            coordinate.tap()
        }
    }
}
