//
//  TranslateViewModelTests.swift
//  BaluchonTests
//
//  Created by Fabrice Etiennette on 24/01/2020.
//  Copyright © 2020 Fabrice Etiennette. All rights reserved.
//

import XCTest
import Moya
@testable import Baluchon

class TranslateViewModelTests: XCTestCase {
    private lazy var stubProvider: MoyaProvider<TranslateAPI> = {
        return .init(stubClosure: MoyaProvider.immediatelyStub)
    }()

    var translateViewModel: TranslateViewModel!
    var translateClient: TranslateClient!

    override func setUp() {
        translateViewModel = TranslateViewModel()
        translateClient = TranslateClient(provider: stubProvider)
    }

    override func tearDown() {
        translateViewModel = nil
        translateClient = nil
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

    func testTranslateClientWhenSuccessButTextNil() {
        // Given:
        let customEndpointClosure = { (target: TranslateAPI) -> Endpoint in
            return Endpoint(
                url: URL(target: target).absoluteString,
                sampleResponseClosure: { .networkResponse(200, Data()) },
                method: target.method,
                task: target.task,
                httpHeaderFields: target.headers
            )
        }
        let stubbingProvider = MoyaProvider<TranslateAPI>(endpointClosure: customEndpointClosure, stubClosure: MoyaProvider.immediatelyStub)
        translateClient = TranslateClient(provider: stubbingProvider)
        let sourceLanguage: Language = .en
        let text = "Hello"
        let expect = expectation(description: "Fetching...")
        var answer: String?
        let translationBody = Translate(source: sourceLanguage, text: text)

        // When:
        translateClient.getTranslatedText(translationBody) { (translatedText, _) in
            answer = translatedText
            expect.fulfill()
        }

        // Then:
        waitForExpectations(timeout: 4) { (error) in
            if error == nil {
                XCTAssertNil(answer)
            }
        }
    }

    func testTranslateClientWhenFailure() {
        // Given:
        let customEndpointClosure = { (target: TranslateAPI) -> Endpoint in
            return Endpoint(
                url: URL(target: target).absoluteString,
                sampleResponseClosure: { .networkResponse(401, target.sampleData) },
                method: target.method,
                task: target.task,
                httpHeaderFields: target.headers
            )
        }
        let stubbingProvider = MoyaProvider<TranslateAPI>(endpointClosure: customEndpointClosure, stubClosure: MoyaProvider.immediatelyStub)
        translateClient = TranslateClient(provider: stubbingProvider)
        let sourceLanguage: Language = .en
        let text = "Hello"
        let translationBody = Translate(source: sourceLanguage, text: text)

        // When:
        translateClient.getTranslatedText(translationBody) { (_, error) in
            let moyaError: MoyaError? = error as? MoyaError
            let response: Response? = moyaError?.response
            let statusCode = response?.statusCode

            // Then:
            XCTAssertEqual(statusCode, 401)
            XCTAssertNotNil(error)
        }
    }
}
