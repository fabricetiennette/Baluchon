// swiftlint:disable closure_parameter_position
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
        app.tabBars.buttons["Translate"].tap()
        app.tabBars.buttons["Today"].tap()
        app.tabBars.buttons["Weather"].tap()
        app.tabBars.buttons["Currency"].tap()
    }

    func testTranslateError() {
        app.tabBars.buttons["Translate"].tap()
        app.buttons["Traduire"].tap()
        app.alerts["Erreur"].buttons["OK"].tap()
    }

    func testTranslateFrToEn() {
        app.tabBars.buttons["Translate"].tap()
        let toTranslate = app.textViews["ToTranslate"]
        toTranslate.tap()
        toTranslate.typeText("Bonjour")
        app.buttons["Traduire"].tap()
        XCTAssertEqual(app.staticTexts.element(matching: .any, identifier: "TextResultLabel").label, "Hello")
    }

    func testTranslateEnToFr() {
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
        app.tabBars.buttons["Weather"].tap()
        let searchBar = app.searchFields["Recherche..."]
        sleep(1)
        searchBar.tap()
        searchBar.typeText("Paris")
        app.buttons["Search"].tap()
    }

    func testTranslateTouchBegan() {
        app.tabBars.buttons["Translate"].tap()
        let toTranslate = app.textViews["ToTranslate"]
        toTranslate.tap()
        toTranslate.typeText("Bonjour")
        app.tap()
        let exists = app.textViews["Bonjour"].exists
        XCTAssertTrue(exists)
    }

    func testCurrencyTouchesBegan() {
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
        app.tabBars.buttons["Currency"].tap()
        app.pickerWheels["GBP"].swipeUp()
        app.pickerWheels["USD"].swipeDown()
        let textField = app.textFields["EUR"]
        sleep(1)
        textField.tap()
        textField.typeText("100")
        app.buttons["Conversions en GBP"].tap()
        let exists = app.buttons["Conversions en GBP"].exists
        XCTAssertTrue(exists)
    }

    func testCurrencyConvertWithMissingText() {
        app.tabBars.buttons["Currency"].tap()
        app.buttons["Conversions"].tap()
    }

    func testCurrencyDecimal() {
        app.tabBars.buttons["Currency"].tap()
        app.pickerWheels["GBP"].swipeUp()
        let textField = app.textFields["EUR"]
        sleep(1)
        textField.tap()
        textField.typeText("10.54")
        app.buttons["Conversions en USD"].tap()
    }

    func testCurrencyDecimalPoint() {
        app.tabBars.buttons["Currency"].tap()
        app.pickerWheels["GBP"].swipeUp()
        let textField = app.textFields["EUR"]
        sleep(1)
        textField.tap()
        textField.typeText("10,54")
        app.buttons["Conversions en USD"].tap()
    }

    func testAppBackground() {
        app.tabBars.buttons["Currency"].tap()
        app.pickerWheels["GBP"].swipeUp()
        let textField = app.textFields["EUR"]
        sleep(1)
        textField.tap()
        textField.typeText("10,54")
        app.buttons["Conversions en USD"].tap()
        app.tabBars.buttons["Weather"].tap()
        XCUIDevice.shared.press(XCUIDevice.Button.home)
        sleep(3)
        app.launch()
        app.tabBars.buttons["Currency"].tap()
    }
}
