//
//  CurrencyViewModelTests.swift
//  BaluchonTests
//
//  Created by Fabrice Etiennette on 27/01/2020.
//  Copyright © 2020 Fabrice Etiennette. All rights reserved.
//

import XCTest
import Moya
@testable import Baluchon

class CurrencyViewModelTests: XCTestCase {
    private lazy var stubProvider: MoyaProvider<CurrencyAPI> = {
        return .init(stubClosure: MoyaProvider.immediatelyStub)
    }()

    var currencyViewModel: CurrencyViewModel!
    var currencyClient: CurrencyClient!

    override func setUp() {
        currencyClient = CurrencyClient(provider: stubProvider)
        currencyViewModel = CurrencyViewModel()
    }

    override func tearDown() {
        currencyClient = nil
        currencyViewModel = nil
        super.tearDown()
    }

    func testCurrencyRatesAndNames() {
        // Given:
        let GBP = 0.843862
        let USD = 1.102475

        // When:
        currencyClient.getExchangeRate { (currencyName, currencyRate, error) in

            // Then:
//            XCTAssertTrue(self.todayViewModel.currencyValues.isEmpty)
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

    func testGetRateFromViewModel() {
        var currencyInArray: Int!
        var namesInArray: Int!
        let expectation = XCTestExpectation(description: "Getting currencies for me...")
        currencyViewModel.getRate { [weak self] in
            guard let me = self else { return }
            currencyInArray = me.currencyViewModel.myCurrency.count
            namesInArray = me.currencyViewModel.myValues.count
            XCTAssertEqual(currencyInArray, 2)
            XCTAssertEqual(namesInArray, 2)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5)
    }
}
