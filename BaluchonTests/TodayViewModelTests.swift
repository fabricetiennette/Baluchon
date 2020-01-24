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
    var todayViewModel: TodayViewModel!
    var provider = MoyaProvider<WeatherAPI>()
    var weatherClient: WeatherClient!
    var geolocationService: GeolocationService!

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        todayViewModel = TodayViewModel()
        weatherClient = WeatherClient()
        geolocationService =  GeolocationService()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        todayViewModel = nil
        weatherClient = nil
        geolocationService = nil
        super.tearDown()
    }

    func testDate() {
        let todayDate = Date()
        let shortDateFormat = "EEEE"
        let longDateFormat = "EEEE dd MMMM"
        let currentDay = todayViewModel.todayDayLabelText
        let currentDayResult = todayDate.formatted(dateFormat: shortDateFormat).capitalized
        let currentLongFormatDay = todayViewModel.dateUILabelText
        let currentLongFormatDayResult = todayDate.formatted(dateFormat: longDateFormat).capitalized
        XCTAssertEqual(currentDay, currentDayResult)
        XCTAssertEqual(currentLongFormatDay, currentLongFormatDayResult)
    }

    func testProvider() {
        let latitude = 33.8688
        let longitude = 151.2093
        let weatherPro = Weather(latitude: latitude, longitude: longitude)
        XCTAssertNotNil(weatherPro)
    }
}
