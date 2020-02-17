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

    func testTranslateError() {
        app.tabBars.buttons["Translate"].tap()
        let button = app.buttons.element(matching: .button, identifier: "traduire")
        button.tap()
        app.alerts["Erreur"].buttons["OK"].tap()
    }

    func testTranslateFrToEn() {
        app.tabBars.buttons["Translate"].tap()
        let toTranslate = app.textViews["ToTranslate"]
        toTranslate.tap()
        toTranslate.typeText("Bonjour")
        let button = app.buttons.element(matching: .button, identifier: "traduire")
        button.tap()
        XCTAssertEqual(app.staticTexts["TextResultLabel"].label, "Hello")
    }

    func testTranslateEnToFr() {
        app.tabBars.buttons["Translate"].tap()
        let button = app.buttons.element(matching: .button, identifier: "exchangeLang")
        button.tap()
        let toTranslate = app.textViews["ToTranslate"]
        toTranslate.tap()
        toTranslate.typeText("Hello")
        let buttonT = app.buttons.element(matching: .button, identifier: "traduire")
        buttonT.tap()
        XCTAssertEqual(app.staticTexts["TextResultLabel"].label, "Bonjour")
    }

    func testWeatherSearch() {
        app.tabBars.buttons["Weather"].tap()
        let searchBar = app.searchFields["Recherche..."].firstMatch
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
        textField.tap()
        textField.typeText("100")
        app.tap()
        let exists = app.textFields["100"].exists
        XCTAssertTrue(exists)
    }

    func testCurrencyConvertWithMissingText() {
        app.tabBars.buttons["Currency"].tap()
        let button = app.buttons.element(matching: .button, identifier: "convertButton")
        button.tap()
    }

    func testCurrencyDecimal() {
        app.tabBars.buttons["Currency"].tap()
        app.pickerWheels.element.adjust(toPickerWheelValue: "GBP")
        app.pickerWheels.element.adjust(toPickerWheelValue: "USD")
        let textField = app.textFields["EUR"]
        textField.tap()
        textField.typeText("10.54")
        let button = app.buttons.element(matching: .button, identifier: "convertButton")
        button.tap()
    }

    func testCurrencyDecimalPoint() {
        app.tabBars.buttons["Currency"].tap()
        app.pickerWheels.element.adjust(toPickerWheelValue: "USD")
        app.pickerWheels.element.adjust(toPickerWheelValue: "GBP")
        let textField = app.textFields["EUR"]
        textField.tap()
        textField.typeText("10,54")
        let button = app.buttons.element(matching: .button, identifier: "convertButton")
        button.tap()
    }
}
