//
//  TranslateClientTests.swift
//  BaluchonTests
//
//  Created by Fabrice Etiennette on 05/02/2020.
//  Copyright © 2020 Fabrice Etiennette. All rights reserved.
//

import XCTest
import Moya
@testable import Baluchon

class TranslateClientTests: XCTestCase {
    private lazy var stubProvider: MoyaProvider<TranslateAPI> = {
        return .init(stubClosure: MoyaProvider.immediatelyStub)
    }()

    var translateClient: TranslateClient!

    override func setUp() {
        super.setUp()
        translateClient = TranslateClient(provider: stubProvider)
    }

    override func tearDown() {
        translateClient = nil
        super.tearDown()
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
        let translationBody = Translate(source: .en, text: "Hello")
        let expect = expectation(description: "Fetching...")

        // When:
        translateClient.getTranslatedText(translationBody) { (translatedText, _) in
            XCTAssertNil(translatedText)
            expect.fulfill()
        }

        // Then:
        wait(for: [expect], timeout: 3)
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
        let translationBody = Translate(source: .en, text: "Hello")
        let expect = expectation(description: "Fetching...")

        // When:
        translateClient.getTranslatedText(translationBody) { (_, error) in
            XCTAssertNotNil(error)
            expect.fulfill()
        }

        // Then:
        wait(for: [expect], timeout: 3)
    }
}
