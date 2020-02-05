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
