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

    enum ResponseError: Error {
        case unknownError
    }

    override func setUp() {
        super.setUp()
        translateViewModel = TranslateViewModel()
    }

    override func tearDown() {
        translateViewModel = nil
        super.tearDown()
    }

    func testTranslationFr() {
        // Given:
        let sourceLanguage: Language = .fr
        let text = "Bonjour"
        let translationBody = Translate(source: sourceLanguage, text: text)
        let expect = expectation(description: "Translating...")

        // When:
        translateViewModel.doTranslation(translationBody: translationBody)
        translateViewModel.translatedTextHandler = { translatedText in
            XCTAssertEqual(translatedText, "Hello")
            expect.fulfill()
        }

        // Then:
        wait(for: [expect], timeout: 3)
    }

    func testTranslationEn() {
        // Given:
        let sourceLanguage: Language = .en
        let text = "Hello"
        let expect = expectation(description: "Translating in french...")
        let translationBody = Translate(source: sourceLanguage, text: text)

        // When:
        translateViewModel.doTranslation(translationBody: translationBody)
        translateViewModel.translatedTextHandler = { translatedText in
            XCTAssertEqual(translatedText, "Bonjour")
            expect.fulfill()
        }

        // Then:
        wait(for: [expect], timeout: 3)
    }
}
