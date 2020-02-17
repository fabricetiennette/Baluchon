//
//  CurrencyClientTests.swift
//  BaluchonTests
//
//  Created by Fabrice Etiennette on 27/01/2020.
//  Copyright © 2020 Fabrice Etiennette. All rights reserved.
//

import XCTest
@testable import Baluchon

class CurrencyClientTests: XCTestCase {

    func testCurrencyErrorData() {
        // Given:
        let currencyClient = CurrencyClient(currencySession: URLSessionFake(data: nil, response: nil, error: FakeResponseData.errorCurrency))
        let expect = expectation(description: "Wait for error to appear.")

        // When:
        currencyClient.getExchangeRate { result in
            if case .failure(let error) = result {
                XCTAssertNotNil(error)
                expect.fulfill()
            }
        }

        // Then:
        wait(for: [expect], timeout: 3)
    }

    func testCurrencyResponseError() {
        // Given:
        let currencyClient = CurrencyClient(currencySession: URLSessionFake(data: FakeResponseData.CurrencyCorrectData, response: FakeResponseData.responseKO, error: nil))
        let expect = expectation(description: "Wait for error to appear.")

        // When:
        currencyClient.getExchangeRate { result in
            if case .failure(let error) = result {
                XCTAssertNotNil(error)
                expect.fulfill()
            }
        }

        // Then:
        wait(for: [expect], timeout: 3)
    }

    func testCurrencyJsonError() {
        // Given:
        let currencyClient = CurrencyClient(currencySession: URLSessionFake(data: FakeResponseData.incorrectData, response: FakeResponseData.responseOK, error: nil))
        let expect = expectation(description: "Wait for error to appear.")

        // When:
        currencyClient.getExchangeRate { result in
            if case .failure(let error) = result {
                XCTAssertNotNil(error)
                expect.fulfill()
            }
        }

        // Then:
        wait(for: [expect], timeout: 3)
    }

    func testCurrencyCorrectJson() {
        // Given:
        let currencyClient = CurrencyClient(currencySession: URLSessionFake(data: FakeResponseData.CurrencyCorrectData, response: FakeResponseData.responseOK, error: nil))
        var myCurrency: [String] = []
        var myValue: [Double] = []
        let expect = expectation(description: "Wait for error to appear.")

        // When:
        currencyClient.getExchangeRate { result in
            if case .success(let currency) = result {
                for (key, value) in Array(currency.rates.sorted(by: {$0.0 < $1.0})) {
                    myCurrency.append(key)
                    myValue.append(value)
                }
                XCTAssertEqual(myCurrency, ["GBP", "USD"])
                XCTAssertEqual(myValue.count, 2)
                expect.fulfill()
            }
        }

        // Then:
        wait(for: [expect], timeout: 3)
    }
}
