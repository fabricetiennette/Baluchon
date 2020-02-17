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
                button.forceTapElement()
            }

            let okButton = alert.buttons["OK"]
            if okButton.exists {
                okButton.forceTapElement()
            }
            return true
        }
    }

    func testTabBar() {
        app.tabBars.buttons["Translate"].forceTapElement()
        app.tabBars.buttons["Today"].forceTapElement()
        app.tabBars.buttons["Weather"].forceTapElement()
        app.tabBars.buttons["Currency"].forceTapElement()
    }

    func testTranslateError() {
        app.tabBars.buttons["Translate"].forceTapElement()
        app.buttons["Traduire"].forceTapElement()
        app.alerts["Erreur"].buttons["OK"].forceTapElement()
    }

    func testTranslateFrToEn() {
        app.tabBars.buttons["Translate"].forceTapElement()
        let toTranslate = app.textViews["ToTranslate"]
        toTranslate.forceTapElement()
        toTranslate.typeText("Bonjour")
        app.buttons["Traduire"].forceTapElement()
        XCTAssertEqual(app.staticTexts.element(matching: .any, identifier: "TextResultLabel").label, "Hello")
    }

    func testTranslateEnToFr() {
        app.tabBars.buttons["Translate"].forceTapElement()
        let exchangeButton = app.buttons["repeat"]
        exchangeButton.forceTapElement()
        let toTranslate = app.textViews["ToTranslate"]
        toTranslate.forceTapElement()
        toTranslate.typeText("Hello")
        app.buttons["Traduire"].forceTapElement()
        XCTAssertEqual(app.staticTexts.element(matching: .any, identifier: "TextResultLabel").label, "Bonjour")
    }

    func testWeatherSearch() {
        app.tabBars.buttons["Weather"].forceTapElement()
        let searchBar = app.searchFields["Recherche..."]
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
        sleep(1)
        textField.forceTapElement()
        textField.typeText("100")
        app.forceTapElement()
        let exists = app.textFields["100"].exists
        XCTAssertTrue(exists)
    }

    func testCurrencyForEurToGBP() {
        app.tabBars.buttons["Currency"].forceTapElement()
        app.pickerWheels["GBP"].swipeUp()
        app.pickerWheels["USD"].swipeDown()
        let textField = app.textFields["EUR"]
        sleep(1)
        textField.forceTapElement()
        textField.typeText("100")
        app.buttons["Conversions en GBP"].forceTapElement()
        let exists = app.buttons["Conversions en GBP"].exists
        XCTAssertTrue(exists)
    }

    func testCurrencyConvertWithMissingText() {
        app.tabBars.buttons["Currency"].forceTapElement()
        app.buttons["Conversions"].forceTapElement()
    }

    func testCurrencyDecimal() {
        app.tabBars.buttons["Currency"].forceTapElement()
        app.pickerWheels["GBP"].swipeUp()
        let textField = app.textFields["EUR"]
        sleep(1)
        textField.forceTapElement()
        textField.typeText("10.54")
        app.buttons["Conversions en USD"].forceTapElement()
    }

    func testCurrencyDecimalPoint() {
        app.tabBars.buttons["Currency"].forceTapElement()
        app.pickerWheels["GBP"].swipeUp()
        let textField = app.textFields["EUR"]
        sleep(1)
        textField.forceTapElement()
        textField.typeText("10,54")
        app.buttons["Conversions en USD"].forceTapElement()
    }

    func testAppBackground() {
        app.tabBars.buttons["Currency"].forceTapElement()
        app.pickerWheels["GBP"].swipeUp()
        let textField = app.textFields["EUR"]
        sleep(1)
        textField.forceTapElement()
        textField.typeText("10,54")
        app.buttons["Conversions en USD"].forceTapElement()
        app.tabBars.buttons["Weather"].forceTapElement()
        XCUIDevice.shared.press(XCUIDevice.Button.home)
        sleep(3)
        app.launch()
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
