//
//  WeatherClientTests.swift
//  BaluchonTests
//
//  Created by Fabrice Etiennette on 05/02/2020.
//  Copyright © 2020 Fabrice Etiennette. All rights reserved.
//

import XCTest
@testable import Baluchon

class WeatherClientTests: XCTestCase {

    var weatherClient: WeatherClient!

    override func setUp() {
        super.setUp()
        weatherClient = WeatherClient()
    }

    override func tearDown() {
        weatherClient = nil
        super.tearDown()
    }
}
