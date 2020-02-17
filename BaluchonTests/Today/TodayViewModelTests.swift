//
//  TodayViewModelTests.swift
//  BaluchonTests
//
//  Created by Fabrice Etiennette on 24/01/2020.
//  Copyright © 2020 Fabrice Etiennette. All rights reserved.
//

import XCTest
@testable import Baluchon

class TodayViewModelTests: XCTestCase {

    let latitude = 37.773972
    let longitude = -122.431297

    func testDateInTodayViewModel() {
        // Given:
        let currencyClient = CurrencyClient()
        let geolocationService = GeolocationService()
        let weatherClient = WeatherClient()
        let todayViewModel = TodayViewModel(
            geolocationService: geolocationService,
            currencyClient: currencyClient,
            weatherClient: weatherClient
        )

        let todayDate = Date()
        let shortDateFormat = "EEEE"
        let longDateFormat = "EEEE dd MMMM"

        // When:
        let viewModelDay = todayViewModel.todayDayLabelText
        let testDay = todayDate.formatted(dateFormat: shortDateFormat).capitalized

        let viewModelLongFormatDay = todayViewModel.dateUILabelText
        let testLongFormatDay = todayDate.formatted(dateFormat: longDateFormat).capitalized

        // Then:
        XCTAssertEqual(viewModelDay, testDay)
        XCTAssertEqual(viewModelLongFormatDay, testLongFormatDay)
    }

    func testUpdateWeatherFromTodayViewModel() {
        // Given:
        let todayGeoLocationStub = TodayGeoLocationStub()
        let currencyClient = CurrencyClient()
        let weatherClient = WeatherClient(
            weatherSession: URLSessionFake(
                data: FakeResponseData.weatherCorrectData,
                response: FakeResponseData.responseOK,
                error: nil
            )
        )
        let todayViewModel = TodayViewModel(
            geolocationService: todayGeoLocationStub,
            currencyClient: currencyClient,
            weatherClient: weatherClient
        )
        let expect = expectation(description: "Wait for errorHandler")

        // When:
        todayViewModel.weatherHandler = { weather in
            XCTAssertEqual(weather.temperature, 8.3.toTemperatureWithDegreeUnit)
            XCTAssertEqual(weather.minTemperature, 5.toTemperatureWithoutDegreeUnit)
            XCTAssertEqual(weather.maxTemperature, 11.11.toTemperatureWithoutDegreeUnit)
            XCTAssertEqual(weather.iconSummary, "partiellement nuageux".capitalized)
            expect.fulfill()
        }
        todayViewModel.updateweather()

        // Then:
        wait(for: [expect], timeout: 3)
    }

    func testErrorHandlerInUpdateLocationFromTodayViewModel() {
        // Given:
        let geoLocationStub = GeoLocationStub()
        let currencyClient = CurrencyClient()
        let weatherClient = WeatherClient(
            weatherSession: URLSessionFake(
                data: FakeResponseData.weatherCorrectData,
                response: FakeResponseData.responseOK,
                error: nil
            )
        )
        let todayViewModel = TodayViewModel(
            geolocationService: geoLocationStub,
            currencyClient: currencyClient,
            weatherClient: weatherClient
        )
        let expect = expectation(description: "Wait for errorHandler")

        // When:
        todayViewModel.errorHandler = { title, message in
            XCTAssertEqual(title, L10n.Localizable.error)
            XCTAssertEqual(message, L10n.Localizable.geolocationerror)
            expect.fulfill()
        }
        todayViewModel.updateweather()

        // Then:
        wait(for: [expect], timeout: 3)
    }

    func testGetRateFromTodayViewModel() {
        // Given:
        let geolocationService = GeolocationService()
        let weatherClient = WeatherClient()
        let currencyClient = CurrencyClient(
            currencySession: URLSessionFake(
                data: FakeResponseData.CurrencyCorrectData,
                response: FakeResponseData.responseOK,
                error: nil
            )
        )
        let todayViewModel = TodayViewModel(
            geolocationService: geolocationService,
            currencyClient: currencyClient,
            weatherClient: weatherClient
        )
        let expect = expectation(description: "Wait for errorHandler")

        // When:
        todayViewModel.rateHandler = { pound, dollar in
            XCTAssertEqual(pound, 0.830135.roundToDecimalAndConvertToString(2))
            XCTAssertEqual(dollar, 1.083085.roundToDecimalAndConvertToString(2))
            expect.fulfill()
        }
        todayViewModel.getRate()

        // Then:
        wait(for: [expect], timeout: 3)
    }

    func testErrorHandlerInGetRateFromTodayViewModel() {
        // Given:
        let geolocationService = GeolocationService()
        let weatherClient = WeatherClient()
        let currencyClient = CurrencyClient(
            currencySession: URLSessionFake(
                data: FakeResponseData.incorrectData,
                response: FakeResponseData.responseOK,
                error: nil
            )
        )
        let todayViewModel = TodayViewModel(
            geolocationService: geolocationService,
            currencyClient: currencyClient,
            weatherClient: weatherClient
        )
        let expect = expectation(description: "Wait for errorHandler")

        // When:
        todayViewModel.errorHandler = { title, message in
            XCTAssertEqual(title, L10n.Localizable.error)
            XCTAssertEqual(message, L10n.Localizable.rateunknown)
            expect.fulfill()
        }
        todayViewModel.getRate()

        // Then:
        wait(for: [expect], timeout: 3)
    }

    func testGetCurrentWeatherInTodayViewModel() {
        // Given:
        let geolocationService = GeolocationService()
        let currencyClient = CurrencyClient()
        let weatherClient = WeatherClient(
            weatherSession: URLSessionFake(
                data: FakeResponseData.weatherCorrectData,
                response: FakeResponseData.responseOK,
                error: nil
            )
        )
        let todayViewModel = TodayViewModel(
            geolocationService: geolocationService,
            currencyClient: currencyClient,
            weatherClient: weatherClient
        )
        let expect = expectation(description: "Wait for errorHandler")

        // When:
        todayViewModel.weatherHandler = { weather in
            XCTAssertEqual(weather.temperature, 8.3.toTemperatureWithDegreeUnit)
            XCTAssertEqual(weather.minTemperature, 5.toTemperatureWithoutDegreeUnit)
            XCTAssertEqual(weather.maxTemperature, 11.11.toTemperatureWithoutDegreeUnit)
            XCTAssertEqual(weather.iconSummary, "partiellement nuageux".capitalized)
            expect.fulfill()
        }
        todayViewModel.getCurrentWeather(latitude: latitude, longitude: longitude)

        // Then:
        wait(for: [expect], timeout: 3)
    }

    func testErrorHandlerFromGetCurrentWeatherInTodayViewModel() {
        // Given:
        let geolocationService = GeolocationService()
        let currencyClient = CurrencyClient()
        let weatherClient = WeatherClient(
            weatherSession: URLSessionFake(
                data: FakeResponseData.incorrectData,
                response: FakeResponseData.responseOK,
                error: nil
            )
        )
        let todayViewModel = TodayViewModel(
            geolocationService: geolocationService,
            currencyClient: currencyClient,
            weatherClient: weatherClient
        )
        let expect = expectation(description: "Wait for errorHandler")

        // When:
        todayViewModel.errorHandler = { title, message in
            XCTAssertEqual(title, L10n.Localizable.error)
            XCTAssertEqual(message, L10n.Localizable.weatherunknown)
            expect.fulfill()
        }
        todayViewModel.getCurrentWeather(latitude: latitude, longitude: longitude)

        // Then:
        wait(for: [expect], timeout: 3)
    }
}
