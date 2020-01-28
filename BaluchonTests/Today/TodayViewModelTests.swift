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
    var weatherClient: WeatherClient!
    var geolocationService: GeolocationService!

    override func setUp() {
        weatherClient = WeatherClient(provider: stubProvider)
        todayViewModel = TodayViewModel()
        geolocationService =  GeolocationService()
    }

    override func tearDown() {
        todayViewModel = nil
        weatherClient = nil
        geolocationService = nil
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

    func testWeatherClient() {
        //Given:
        let latitude = 37.8267
        let longitude = -122.4233

        //When:
        weatherClient.getCurrentWeather(latitude: latitude, longitude: longitude) { (daily, currently, error) in
            let currentWeather = currently.first

            // Then:
            XCTAssertEqual(currentWeather?.summary, "Ciel Dégagé")
            XCTAssertEqual(currentWeather?.icon, "clear-night")
            XCTAssertEqual(currentWeather?.temperature, 10.78)
            XCTAssertEqual(currentWeather?.humidity, 0.79)
            XCTAssertEqual(currentWeather?.windSpeed, 2.34)
            XCTAssertEqual(currentWeather?.uvIndex, 0)
            XCTAssertEqual(currentWeather?.visibility, 16.093)

            XCTAssertEqual(daily[0].summary, "Pluie faible dans la matinée.")
            XCTAssertEqual(daily[1].icon, "partly-cloudy-day")
            XCTAssertEqual(daily[2].time, 1580198400)
            XCTAssertEqual(daily[2].summary, "Ciel couvert toute la journée.")
            XCTAssertEqual(daily[3].temperatureMin, 7.75)
            XCTAssertEqual(daily[4].uvIndex, 3)
            XCTAssertEqual(daily[5].sunriseTime, 1580483760)
            XCTAssertEqual(daily[6].dewPoint, 10.32)
            XCTAssertEqual(daily[7].temperatureMax, 14.56)

            XCTAssertEqual(error?.localizedDescription, nil)
        }
    }

    func testWeatherClientWhenCaseFailure() {
        // Given:
        let customEndpointClosure = { (target: WeatherAPI) -> Endpoint in
            return Endpoint(
                url: URL(target: target).absoluteString,
                sampleResponseClosure: { .networkResponse(401, target.sampleData) },
                method: target.method,
                task: target.task,
                httpHeaderFields: target.headers
            )
        }
        let stubbingProvider = MoyaProvider<WeatherAPI>(endpointClosure: customEndpointClosure, stubClosure: MoyaProvider.immediatelyStub)
        let latitude = 37.8267
        let longitude = -122.4233
        weatherClient = WeatherClient(provider: stubbingProvider)

        // When:
        weatherClient.getCurrentWeather(latitude: latitude, longitude: longitude) { (_, _, error) in
            let moyaError: MoyaError? = error as? MoyaError
            let response: Response? = moyaError?.response
            let statusCode = response?.statusCode

            // Then:
            XCTAssertEqual(statusCode, 401)
            XCTAssertNotNil(error)
        }
    }

    func testWeatherClientWhenCaseSuccessButEndpointEmpty() {
        // Given:
        let customEndpointClosure = { (target: WeatherAPI) -> Endpoint in
            return Endpoint(
                url: URL(target: target).absoluteString,
                sampleResponseClosure: { .networkResponse(200, Data()) },
                method: target.method,
                task: target.task,
                httpHeaderFields: target.headers
            )
        }
        let stubbingProvider = MoyaProvider<WeatherAPI>(endpointClosure: customEndpointClosure, stubClosure: MoyaProvider.immediatelyStub)
        let latitude = 37.8267
        let longitude = -122.4233
        weatherClient = WeatherClient(provider: stubbingProvider)

        // When:
        weatherClient.getCurrentWeather(latitude: latitude, longitude: longitude) { (daily, currently, error) in
            let moyaError: MoyaError? = error as? MoyaError
            let response: Response? = moyaError?.response
            let statusCode = response?.statusCode

            // Then:
            XCTAssertNil(currently.first?.icon)
            XCTAssertNil(daily.first?.summary)
            XCTAssertEqual(statusCode, 200)
            XCTAssertNotNil(error)
        }
    }
}
