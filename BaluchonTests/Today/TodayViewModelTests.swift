//
//  TodayViewModelTests.swift
//  BaluchonTests
//
//  Created by Fabrice Etiennette on 24/01/2020.
//  Copyright © 2020 Fabrice Etiennette. All rights reserved.
//

import XCTest
import Moya
import CoreLocation
@testable import Baluchon

class TodayViewModelTests: XCTestCase {
    private lazy var stubProvider: MoyaProvider<WeatherAPI> = {
        return .init(stubClosure: MoyaProvider.immediatelyStub)
    }()

    var todayViewModel: TodayViewModel!

    override func setUp() {
        super.setUp()
        let currencyClient = CurrencyClient()
        let geolocationService = GeolocationService()
        let weatherClient = WeatherClient(provider: stubProvider)
        todayViewModel = TodayViewModel(
            geolocationService: geolocationService,
            currencyClient: currencyClient,
            weatherClient: weatherClient
        )
    }

    override func tearDown() {
        todayViewModel = nil
        super.tearDown()
    }

    func testDate() {
        // Given:
        let todayDate = Date()
        let shortDateFormat = "EEEE"
        let longDateFormat = "EEEE dd MMMM"
        // When:
        let currentDay = todayViewModel.todayDayLabelText
        let currentDayResult = todayDate.formatted(dateFormat: shortDateFormat).capitalized
        let currentLongFormatDay = todayViewModel.dateUILabelText
        let currentLongFormatDayResult = todayDate.formatted(dateFormat: longDateFormat).capitalized
        // Then:
        XCTAssertEqual(currentDay, currentDayResult)
        XCTAssertEqual(currentLongFormatDay, currentLongFormatDayResult)
    }
}
