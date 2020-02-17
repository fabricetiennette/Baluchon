//
//  CurrencyViewModelTests.swift
//  BaluchonTests
//
//  Created by Fabrice Etiennette on 05/02/2020.
//  Copyright © 2020 Fabrice Etiennette. All rights reserved.
//

import XCTest
@testable import Baluchon

class CurrencyViewModelTests: XCTestCase {

    var currencyViewModel: CurrencyViewModel!

    override func setUp() {
        super.setUp()
        currencyViewModel = CurrencyViewModel()
    }

    override func tearDown() {
        currencyViewModel = nil
        super.tearDown()
    }

    func testGetRateFromCurrencyViewModel() {
        // Given:
        var currencyInArray: Int!
        var namesInArray: Int!
        let expect = expectation(description: "Getting currencies for me...")

        // When:
        currencyViewModel.getRate { [weak self] in
            guard let me = self else { return }
            currencyInArray = me.currencyViewModel.myCurrency.count
            namesInArray = me.currencyViewModel.myValues.count
            XCTAssertEqual(currencyInArray, 2)
            XCTAssertEqual(namesInArray, 2)
            expect.fulfill()
        }

        // Then:
        wait(for: [expect], timeout: 3)
    }

    func testCurrencyErrorHandler() {
        // Given:
        let currencyClient = CurrencyClient(currencySession: URLSessionFake(data: FakeResponseData.incorrectData, response: FakeResponseData.responseOK, error: nil))
        let currencyViewModel = CurrencyViewModel(currencyClient: currencyClient)
        let expect = expectation(description: "Waiting for error...")

        // When:
        currencyViewModel.errorHandler = { title, message in
            XCTAssertEqual(title, "Erreur")
            XCTAssertEqual(message, "Taux de change indisponible pour le moment…")
            expect.fulfill()
        }
        currencyViewModel.getRate {}

        // Then:
        wait(for: [expect], timeout: 3)
    }
}
