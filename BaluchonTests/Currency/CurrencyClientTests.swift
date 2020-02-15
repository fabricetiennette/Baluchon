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

    var currencyClient: CurrencyClient!

    override func setUp() {
        super.setUp()
        currencyClient = CurrencyClient()
    }

    override func tearDown() {
        currencyClient = nil
        super.tearDown()
    }

}
