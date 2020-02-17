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
        app.tabBars.buttons["Translate"].forceTapElement()
        app.tabBars.buttons["Today"].forceTapElement()
        app.tabBars.buttons["Weather"].forceTapElement()
        app.tabBars.buttons["Currency"].forceTapElement()
    }

    func testTranslateError() {
        app.tabBars.buttons["Translate"].forceTapElement()
        let button = app.buttons.element(matching: .button, identifier: "Traduire")
        button.forceTapElement()
        app.alerts["Erreur"].buttons["OK"].forceTapElement()
    }

    func testTranslateFrToEn() {
        app.tabBars.buttons["Translate"].forceTapElement()
        let toTranslate = app.textViews["ToTranslate"]
        toTranslate.forceTapElement()
        toTranslate.typeText("Bonjour")
        let button = app.buttons.element(matching: .button, identifier: "Traduire")
        button.forceTapElement()
        XCTAssertEqual(app.staticTexts["TextResultLabel"].label, "Hello")
    }

    func testTranslateEnToFr() {
        app.tabBars.buttons["Translate"].forceTapElement()
        let button = app.buttons.element(matching: .button, identifier: "exchangeLang")
        button.forceTapElement()
        let toTranslate = app.textViews["ToTranslate"]
        toTranslate.forceTapElement()
        toTranslate.typeText("Hello")
        let buttonT = app.buttons.element(matching: .button, identifier: "Traduire")
        buttonT.forceTapElement()
        XCTAssertEqual(app.staticTexts["TextResultLabel"].label, "Bonjour")
    }

    func testWeatherSearch() {
        app.tabBars.buttons["Weather"].forceTapElement()
        let searchBar = app.searchFields["Recherche..."].firstMatch
        sleep(1)
        searchBar.forceTapElement()
        searchBar.typeText("Paris")
        app.buttons["Search"].forceTapElement()
    }

    func testTranslateTouchBegan() {
        app.tabBars.buttons["Translate"].forceTapElement()
        let toTranslate = app.textViews["ToTranslate"]
        toTranslate.forceTapElement()
        toTranslate.typeText("Bonjour")
        app.forceTapElement()
        let exists = app.textViews["Bonjour"].exists
        XCTAssertTrue(exists)
    }

    func testCurrencyTouchesBegan() {
        app.tabBars.buttons["Currency"].forceTapElement()
        let textField = app.textFields["EUR"]
        textField.forceTapElement()
        textField.typeText("100")
        app.forceTapElement()
        let exists = app.textFields["100"].exists
        XCTAssertTrue(exists)
    }

    func testCurrencyConvertWithMissingText() {
        app.tabBars.buttons["Currency"].forceTapElement()
        let button = app.buttons.element(matching: .button, identifier: "convertButton")
        button.forceTapElement()
    }

    func testCurrencyDecimal() {
        app.tabBars.buttons["Currency"].forceTapElement()
        app.pickerWheels.element.adjust(toPickerWheelValue: "GBP")
        app.pickerWheels.element.adjust(toPickerWheelValue: "USD")
        let textField = app.textFields["EUR"]
        textField.forceTapElement()
        textField.typeText("10.54")
        let button = app.buttons.element(matching: .button, identifier: "convertButton")
        button.forceTapElement()
    }

    func testCurrencyDecimalPoint() {
        app.tabBars.buttons["Currency"].forceTapElement()
        app.pickerWheels.element.adjust(toPickerWheelValue: "USD")
        app.pickerWheels.element.adjust(toPickerWheelValue: "GBP")
        let textField = app.textFields["EUR"]
        textField.forceTapElement()
        textField.typeText("10,54")
        let button = app.buttons.element(matching: .button, identifier: "convertButton")
        button.forceTapElement()
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
