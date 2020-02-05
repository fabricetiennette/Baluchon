//
//  CurrencyClientTests.swift
//  BaluchonTests
//
//  Created by Fabrice Etiennette on 27/01/2020.
//  Copyright © 2020 Fabrice Etiennette. All rights reserved.
//

import XCTest
import Moya
@testable import Baluchon

class CurrencyClientTests: XCTestCase {
    private lazy var stubProvider: MoyaProvider<CurrencyAPI> = {
        return .init(stubClosure: MoyaProvider.immediatelyStub)
    }()

    var currencyClient: CurrencyClient!

    override func setUp() {
        super.setUp()
        currencyClient = CurrencyClient(provider: stubProvider)
    }

    override func tearDown() {
        currencyClient = nil
        super.tearDown()
    }

    func testCurrencyRatesAndNames() {
        // Given:
        let GBP = 0.843862
        let USD = 1.102475

        // When:
        currencyClient.getExchangeRate { (currencyName, currencyRate, error) in

            // Then:
            XCTAssertEqual(GBP, currencyRate.first)
            XCTAssertEqual(USD, currencyRate.last)
            XCTAssertEqual(currencyName.first, "GBP")
            XCTAssertEqual(currencyName.last, "USD")
            XCTAssertNil(error)
        }
    }

    func testCurrencyClientSuccessButNil() {
        // Given:
        let customEndpointClosure = { (target: CurrencyAPI) -> Endpoint in
            return Endpoint(
                url: URL(target: target).absoluteString,
                sampleResponseClosure: { .networkResponse(200, Data()) },
                method: target.method,
                task: target.task,
                httpHeaderFields: target.headers
            )
        }
        let stubbingProvider = MoyaProvider<CurrencyAPI>(endpointClosure: customEndpointClosure, stubClosure: MoyaProvider.immediatelyStub)
        currencyClient = CurrencyClient(provider: stubbingProvider)

        // When:
        currencyClient.getExchangeRate { (currencyName, currencyRate, error) in

            // Then:
            XCTAssertEqual(currencyName, [])
            XCTAssertEqual(currencyRate, [])
            XCTAssertNotNil(error)
        }
    }

    func testCurrencyClientFailure() {
        // Given:
        let customEndpointClosure = { (target: CurrencyAPI) -> Endpoint in
            return Endpoint(
                url: URL(target: target).absoluteString,
                sampleResponseClosure: { .networkResponse(401, target.sampleData) },
                method: target.method,
                task: target.task,
                httpHeaderFields: target.headers
            )
        }
        let stubbingProvider = MoyaProvider<CurrencyAPI>(endpointClosure: customEndpointClosure, stubClosure: MoyaProvider.immediatelyStub)
        currencyClient = CurrencyClient(provider: stubbingProvider)

        // When:
        currencyClient.getExchangeRate { (currencyName, currencyRate, error) in
            let moyaError: MoyaError? = error as? MoyaError
            let response: Response? = moyaError?.response
            let statusCode = response?.statusCode

            // Then:
            XCTAssertEqual(currencyName, [])
            XCTAssertEqual(currencyRate, [])
            XCTAssertEqual(currencyName, [])
            XCTAssertEqual(statusCode, 401)
            XCTAssertNotNil(error)
        }
    }
}
