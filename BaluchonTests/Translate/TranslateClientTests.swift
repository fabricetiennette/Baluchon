//
//  TranslateClientTests.swift
//  BaluchonTests
//
//  Created by Fabrice Etiennette on 05/02/2020.
//  Copyright © 2020 Fabrice Etiennette. All rights reserved.
//

import XCTest
@testable import Baluchon

class TranslateClientTests: XCTestCase {

    func testTranslateDataErrorCallback() {
        // Given:
        let translateClient = TranslateClient(translateSession: URLSessionFake(data: nil, response: nil, error: FakeResponseData.errorTranslate))
        let translationBody = Translate(source: .fr, text: "Bonjour")
        let expect = expectation(description: "Wait for error to appear.")

        // When:
        translateClient.getTranslatedText(translationBody) { result in
            if case .failure(let error) = result {
                XCTAssertNotNil(error)
                expect.fulfill()
            }
        }

        // Then:
        wait(for: [expect], timeout: 2)
    }

    func testTranslateResponseErrorCallback() {
        // Given:
        let translateClient = TranslateClient(translateSession: URLSessionFake(data: FakeResponseData.translateCorrectData, response: FakeResponseData.responseKO, error: nil))
        let translationBody = Translate(source: .fr, text: "Bonjour")
        let expect = expectation(description: "Wait for error to appear.")

        // When:
        translateClient.getTranslatedText(translationBody) { result in
            if case .failure(let error) = result {
                XCTAssertNotNil(error)
                expect.fulfill()
            }
        }

        // Then:
        wait(for: [expect], timeout: 2)
    }

    func testTranslateJsonErrorCallback() {
        // Given:
        let translateClient = TranslateClient(translateSession: URLSessionFake(data: FakeResponseData.incorrectData, response: FakeResponseData.responseOK, error: nil))
        let translationBody = Translate(source: .fr, text: "Bonjour")
        let expect = expectation(description: "Wait for error to appear.")

        // When:
        translateClient.getTranslatedText(translationBody) { result in
            if case .failure(let error) = result {
                XCTAssertNotNil(error)
                expect.fulfill()
            }
        }

        // Then:
        wait(for: [expect], timeout: 2)
    }

    func testTranslateDoTranslate() {
        // Given:
        let translateClient = TranslateClient(translateSession: URLSessionFake(data: FakeResponseData.translateCorrectData, response: FakeResponseData.responseOK, error: nil))
        let translationBody = Translate(source: .fr, text: "Bonjour")
        let expect = expectation(description: "Wait for Hello")

        // When:
        translateClient.getTranslatedText(translationBody) { result in
            if case .success(let text) = result {
                XCTAssertEqual(text.translatedText, "Hello")
                expect.fulfill()
            }
        }

        // Then:
        wait(for: [expect], timeout: 2)
    }
}
