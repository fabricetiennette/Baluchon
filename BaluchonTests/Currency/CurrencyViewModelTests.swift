//
//  CurrencyViewModelTests.swift
//  BaluchonTests
//
//  Created by Fabrice Etiennette on 05/02/2020.
//  Copyright © 2020 Fabrice Etiennette. All rights reserved.
//

import XCTest
@testable import Baluchon

class CurrencyClientStub: CurrencyClient {

    override func getExchangeRate(callback: @escaping ([String], [Double], Error?) -> Void) {
        let error = ResponseError.unknownError
        callback([], [], error)
    }
}

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

    func testGetRateFromViewModel() {
        // Given:
        var currencyInArray: Int!
        var namesInArray: Int!
        let expectation = XCTestExpectation(description: "Getting currencies for me...")

        // When:
        currencyViewModel.getRate { [weak self] in
            guard let me = self else { return }
            currencyInArray = me.currencyViewModel.myCurrency.count
            namesInArray = me.currencyViewModel.myValues.count
            XCTAssertEqual(currencyInArray, 2)
            XCTAssertEqual(namesInArray, 2)
            expectation.fulfill()
        }

        // Then:
        wait(for: [expectation], timeout: 5)
    }

    func testErrorHandler() {
        // Given:
        let currencyStub = CurrencyClientStub()
        let currencyViewModel = CurrencyViewModel(currencyClient: currencyStub)
        let expect = expectation(description: "waiting for error...")

        // When:
        currencyViewModel.errorHandler = { title, message in
            XCTAssertEqual(title, "Erreur")
            XCTAssertEqual(message, "Taux de change indisponible pour le moment...")
            expect.fulfill()
        }
        currencyViewModel.getRate {  }

        // Then:
        wait(for: [expect], timeout: 5)
    }
}
