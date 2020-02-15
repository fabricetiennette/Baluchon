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

    var translateClient: TranslateClient!

    override func setUp() {
        super.setUp()
        translateClient = TranslateClient()
    }

    override func tearDown() {
        translateClient = nil
        super.tearDown()
    }

}
