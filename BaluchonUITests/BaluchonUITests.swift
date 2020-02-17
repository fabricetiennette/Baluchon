// swiftlint:disable closure_parameter_position type_body_length
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
    }

    override func tearDown() {
        super.tearDown()
    }

    func testRequestGeoLocationAndNotification() {
        addUIInterruptionMonitor(withDescription: "System Dialog") {
            (alert) -> Bool in
            let button = alert.buttons["Allow Once"]
            if button.exists {
                button.tap()
            }

            let okButton = alert.buttons["OK"]
            if okButton.exists {
                okButton.tap()
            }
            return true
        }
    }

    func testTabBar() {
        addUIInterruptionMonitor(withDescription: "System Dialog") {
            (alert) -> Bool in
            let button = alert.buttons["Allow Once"]
            if button.exists {
                button.tap()
            }

            let okButton = alert.buttons["OK"]
            if okButton.exists {
                okButton.tap()
            }
            return true
        }
        app.tabBars.buttons["Translate"].tap()
        app.tabBars.buttons["Today"].tap()
        app.tabBars.buttons["Weather"].tap()
        app.tabBars.buttons["Currency"].tap()
    }

    func testTranslateError() {
        addUIInterruptionMonitor(withDescription: "System Dialog") {
            (alert) -> Bool in
            let button = alert.buttons["Allow Once"]
            if button.exists {
                button.tap()
            }

            let okButton = alert.buttons["OK"]
            if okButton.exists {
                okButton.tap()
            }
            return true
        }
        app.tabBars.buttons["Translate"].tap()
        app.buttons["Traduire"].tap()
        app.alerts["error"].buttons["OK"].tap()
    }

    func testTranslateFrToEn() {
        addUIInterruptionMonitor(withDescription: "System Dialog") {
            (alert) -> Bool in
            let button = alert.buttons["Allow Once"]
            if button.exists {
                button.tap()
            }

            let okButton = alert.buttons["OK"]
            if okButton.exists {
                okButton.tap()
            }
            return true
        }
        app.tabBars.buttons["Translate"].tap()
        let toTranslate = app.textViews["ToTranslate"]
        toTranslate.tap()
        toTranslate.typeText("Bonjour")
        app.buttons["Traduire"].tap()
        XCTAssertEqual(app.staticTexts.element(matching: .any, identifier: "TextResultLabel").label, "Hello")
    }

    func testTranslateEnToFr() {
        addUIInterruptionMonitor(withDescription: "System Dialog") {
            (alert) -> Bool in
            let button = alert.buttons["Allow Once"]
            if button.exists {
                button.tap()
            }

            let okButton = alert.buttons["OK"]
            if okButton.exists {
                okButton.tap()
            }
            return true
        }
        app.tabBars.buttons["Translate"].tap()
        let exchangeButton = app.buttons["repeat"]
        exchangeButton.tap()
        let toTranslate = app.textViews["ToTranslate"]
        toTranslate.tap()
        toTranslate.typeText("Hello")
        app.buttons["Traduire"].tap()
        XCTAssertEqual(app.staticTexts.element(matching: .any, identifier: "TextResultLabel").label, "Bonjour")
    }

    func testWeatherSearch() {
       addUIInterruptionMonitor(withDescription: "System Dialog") {
            (alert) -> Bool in
            let button = alert.buttons["Allow Once"]
            if button.exists {
                button.tap()
            }

            let okButton = alert.buttons["OK"]
            if okButton.exists {
                okButton.tap()
            }
            return true
        }
        app.tabBars.buttons["Weather"].tap()
        let searchBar = app.searchFields["Recherche..."]
        sleep(1)
        searchBar.tap()
        searchBar.typeText("Paris")
        app.buttons["Search"].tap()
    }

    func testTranslateTouchBegan() {
        addUIInterruptionMonitor(withDescription: "System Dialog") {
            (alert) -> Bool in
            let button = alert.buttons["Allow Once"]
            if button.exists {
                button.tap()
            }

            let okButton = alert.buttons["OK"]
            if okButton.exists {
                okButton.tap()
            }
            return true
        }
        app.tabBars.buttons["Translate"].tap()
        let toTranslate = app.textViews["ToTranslate"]
        toTranslate.tap()
        toTranslate.typeText("Bonjour")
        app.tap()
        let exists = app.textViews["Bonjour"].exists
        XCTAssertTrue(exists)
    }

    func testCurrencyTouchesBegan() {
        addUIInterruptionMonitor(withDescription: "System Dialog") {
            (alert) -> Bool in
            let button = alert.buttons["Allow Once"]
            if button.exists {
                button.tap()
            }

            let okButton = alert.buttons["OK"]
            if okButton.exists {
                okButton.tap()
            }
            return true
        }
        app.tabBars.buttons["Currency"].tap()
        let textField = app.textFields["EUR"]
        sleep(1)
        textField.tap()
        textField.typeText("100")
        app.tap()
        let exists = app.textFields["100"].exists
        XCTAssertTrue(exists)
    }

    func testCurrencyForEurToGBP() {
        addUIInterruptionMonitor(withDescription: "System Dialog") {
            (alert) -> Bool in
            let button = alert.buttons["Allow Once"]
            if button.exists {
                button.tap()
            }

            let okButton = alert.buttons["OK"]
            if okButton.exists {
                okButton.tap()
            }
            return true
        }
        app.tabBars.buttons["Currency"].tap()
        app.pickerWheels["GBP"].swipeUp()
        app.pickerWheels["USD"].swipeDown()
        let textField = app.textFields["EUR"]
        sleep(1)
        textField.tap()
        textField.typeText("100")
        app.buttons["convert GBP"].tap()
        let exists = app.buttons["convert GBP"].exists
        XCTAssertTrue(exists)
    }

    func testCurrencyConvertWithMissingText() {
        addUIInterruptionMonitor(withDescription: "System Dialog") {
            (alert) -> Bool in
            let button = alert.buttons["Allow Once"]
            if button.exists {
                button.tap()
            }

            let okButton = alert.buttons["OK"]
            if okButton.exists {
                okButton.tap()
            }
            return true
        }
        app.tabBars.buttons["Currency"].tap()
        app.buttons["Conversions"].tap()
    }

    func testCurrencyDecimal() {
        addUIInterruptionMonitor(withDescription: "System Dialog") {
            (alert) -> Bool in
            let button = alert.buttons["Allow Once"]
            if button.exists {
                button.tap()
            }

            let okButton = alert.buttons["OK"]
            if okButton.exists {
                okButton.tap()
            }
            return true
        }
        app.tabBars.buttons["Currency"].tap()
        app.pickerWheels["GBP"].swipeUp()
        let textField = app.textFields["EUR"]
        sleep(1)
        textField.tap()
        textField.typeText("10.54")
        app.buttons["convert USD"].tap()
    }

    func testCurrencyDecimalPoint() {
        addUIInterruptionMonitor(withDescription: "System Dialog") {
            (alert) -> Bool in
            let button = alert.buttons["Allow Once"]
            if button.exists {
                button.tap()
            }

            let okButton = alert.buttons["OK"]
            if okButton.exists {
                okButton.tap()
            }
            return true
        }
        app.tabBars.buttons["Currency"].tap()
        app.pickerWheels["GBP"].swipeUp()
        let textField = app.textFields["EUR"]
        sleep(1)
        textField.tap()
        textField.typeText("10,54")
        app.buttons["convert USD"].tap()
    }

    func testAppBackground() {
        addUIInterruptionMonitor(withDescription: "System Dialog") {
            (alert) -> Bool in
            let button = alert.buttons["Allow Once"]
            if button.exists {
                button.tap()
            }

            let okButton = alert.buttons["OK"]
            if okButton.exists {
                okButton.tap()
            }
            return true
        }
        app.tabBars.buttons["Currency"].tap()
        app.pickerWheels["GBP"].swipeUp()
        let textField = app.textFields["EUR"]
        sleep(1)
        textField.tap()
        textField.typeText("10,54")
        app.buttons["convert USD"].tap()
        app.tabBars.buttons["Weather"].tap()
        XCUIDevice.shared.press(XCUIDevice.Button.home)
        sleep(10)
        app.launch()
        app.tabBars.buttons["Currency"].tap()
    }
}
