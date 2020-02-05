//
//  TranslateViewModelTests.swift
//  BaluchonTests
//
//  Created by Fabrice Etiennette on 24/01/2020.
//  Copyright © 2020 Fabrice Etiennette. All rights reserved.
//

import XCTest
@testable import Baluchon

class TranslateViewModelTests: XCTestCase {

    var translateViewModel: TranslateViewModel!

    override func setUp() {
        super.setUp()
        translateViewModel = TranslateViewModel()
    }

    override func tearDown() {
        translateViewModel = nil
        super.tearDown()
    }

    func testTranslationFr() {
        let sourceLanguage: Language = .fr
        let text = "Bonjour"
        let expect = expectation(description: "Fetching...")
        var answer: String?
        let translationBody = Translate(source: sourceLanguage, text: text)
        translateViewModel.doTranslation(translationBody: translationBody)
        translateViewModel.translatedTextHandler = { translatedText in
                answer = translatedText
                expect.fulfill()
        }
        waitForExpectations(timeout: 5) { (error) in
            XCTAssertNil(error)
            XCTAssertNotNil(answer)
            XCTAssertEqual(answer, "Hello")
        }
    }

    func testTranslationEn() {
        let sourceLanguage: Language = .en
        let text = "Hello"
        let expect = expectation(description: "Fetching...")
        var answer: String?
        let translationBody = Translate(source: sourceLanguage, text: text)
        translateViewModel.doTranslation(translationBody: translationBody)
        translateViewModel.translatedTextHandler = { translatedText in
                answer = translatedText
                expect.fulfill()
        }
        waitForExpectations(timeout: 5) { (error) in
            XCTAssertNil(error)
            XCTAssertNotNil(answer)
            XCTAssertEqual(answer, "Bonjour")
        }
    }

    func testTextHandler() {
        let expect = expectation(description: "Fetching...")
        let text = "Bonjour"
        var answer: String?

        translateViewModel.translatedTextHandler = { translatedText in
                answer = translatedText
                expect.fulfill()
        }
        translateViewModel.translatedTextHandler(text)
        waitForExpectations(timeout: 2) { (error) in
            XCTAssertNil(error)
            XCTAssertNotNil(answer)
            XCTAssertEqual(answer, "Bonjour")
        }
    }

    func testErrorHandler() {
           let expect = expectation(description: "wait for it")
           let title = "Erreur"

           translateViewModel.errorHandler = { titleText, messageText in
               XCTAssertEqual(titleText, title)
               expect.fulfill()
           }
           translateViewModel.errorHandler("Erreur", "Unknown location...")
           wait(for: [expect], timeout: 5)
       }
}
