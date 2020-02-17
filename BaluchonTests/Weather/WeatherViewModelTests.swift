//
//  WeatherViewModelTests.swift
//  BaluchonTests
//
//  Created by Fabrice Etiennette on 28/01/2020.
//  Copyright © 2020 Fabrice Etiennette. All rights reserved.
//

import XCTest
@testable import Baluchon

class WeatherViewModelTests: XCTestCase {

    let latitude = 37.773972
    let longitude = -122.431297

    func testWeatherViewModelErrorHandlerWithGetCurrentWeather() {
        // Given:
        let geolocationService = GeolocationService()
        let weatherClient = WeatherClient(weatherSession: URLSessionFake(data: FakeResponseData.incorrectData, response: FakeResponseData.responseOK, error: nil))
        let weatherViewModel = WeatherViewModel(geolocationService: geolocationService, weatherClient: weatherClient)
        let expect = expectation(description: "Wait for error.")

        // When:
        weatherViewModel.errorHandler = { title, message in
            XCTAssertEqual(title, "Erreur")
            XCTAssertEqual(message, "Météo indisponible pour le moment…")
            expect.fulfill()
        }
        weatherViewModel.getCurrentWeather(latitude: latitude, longitude: longitude)

        // Then:
        wait(for: [expect], timeout: 3)
    }

    func testErrorHandlerAndLocationInUpdateWeather() {
        // Given:
        let weatherGeoLocationStub = WeatherGeoLocationStub()
        let weatherClient = WeatherClient(weatherSession: URLSessionFake(data: FakeResponseData.weatherCorrectData, response: FakeResponseData.responseOK, error: nil))
        let weatherViewModel = WeatherViewModel(geolocationService: weatherGeoLocationStub, weatherClient: weatherClient)
        var newLocation = ""
        let expect = expectation(description: "Wait for error.")

        // When:
        weatherViewModel.errorHandler = { title, message in
            newLocation = weatherViewModel.location
            XCTAssertEqual(title, "Erreur")
            XCTAssertEqual(message, "Localisation inconnue…")
            XCTAssertEqual(newLocation, "Paris")
            expect.fulfill()
        }
        weatherViewModel.updateWeather("Paris")

        // Then:
        wait(for: [expect], timeout: 3)
    }

    func testUpdateWeatherInWeatherViewModel() {
        // Given:
        let geolocationService = GeolocationService()
        let weatherClient = WeatherClient()
        let weatherViewModel = WeatherViewModel(geolocationService: geolocationService, weatherClient: weatherClient)
        let expect = expectation(description: "Wait for error.")

        // When:
        weatherViewModel.weatherHandler = { weather in
            XCTAssertNotNil(weather)
            expect.fulfill()
        }
        weatherViewModel.updateWeather("Paris")

        // Then:
        wait(for: [expect], timeout: 3)
    }

    func testGetCurrentWeatherInWeatherViewModel() {
        // Given:
        let geolocationService = GeolocationService()
        let weatherClient = WeatherClient(weatherSession: URLSessionFake(data: FakeResponseData.weatherCorrectData, response: FakeResponseData.responseOK, error: nil))
        let weatherViewModel = WeatherViewModel(geolocationService: geolocationService, weatherClient: weatherClient)
        let expect = expectation(description: "Wait for error.")

        // When:
        weatherViewModel.weatherHandler = { weather in
            XCTAssertEqual(weather.temperature, 8.3.toTemperatureWithDegreeUnit)
            XCTAssertEqual(weather.minTemperature, 5.toTemperatureWithoutDegreeUnit)
            XCTAssertEqual(weather.maxTemperature, 11.11.toTemperatureWithoutDegreeUnit)
            XCTAssertEqual(weather.iconSummary, "partiellement nuageux".capitalized)
            expect.fulfill()
        }
        weatherViewModel.getCurrentWeather(latitude: latitude, longitude: longitude)

        // Then:
        wait(for: [expect], timeout: 3)
    }
}
