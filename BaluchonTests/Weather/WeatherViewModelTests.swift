//
//  WeatherViewModelTests.swift
//  BaluchonTests
//
//  Created by Fabrice Etiennette on 28/01/2020.
//  Copyright © 2020 Fabrice Etiennette. All rights reserved.
//

import XCTest
import CoreLocation
@testable import Baluchon


class WeatherViewModelTests: XCTestCase {

    var weatherViewModel: WeatherViewModel!

    override func setUp() {
        super.setUp()
        let geolocationService = GeolocationService()
        let weatherClient = WeatherClient()
        weatherViewModel = WeatherViewModel(
            geolocationService: geolocationService,
            weatherClient: weatherClient
        )
    }

    override func tearDown() {
        weatherViewModel = nil
        super.tearDown()
    }

    
    func testCurrentLocationWhencCurrentPlaceIsNotEmpty() {
        // Given:
        let weatherClient = WeatherClient()
        let weatherViewModel = WeatherViewModel(
            weatherClient: weatherClient
        )
        var unKnowLocation: String?

        // When:
        unKnowLocation = weatherViewModel.location

        // Then:
        XCTAssertEqual(unKnowLocation, "San Francisco")
    }

    func testWeatherForcastAndCurrentDataArrayIsEmpty() {
        // Given:
        let latitude = 37.8267
        let longitude = -122.4233

        // When:
        weatherViewModel.getCurrentWeather(latitude: latitude, longitude: longitude)

        // Then:
//        XCTAssertFalse(weatherViewModel.forcastData.isEmpty)
//        XCTAssertFalse(weatherViewModel.currentForcast.isEmpty)
    }

    func testErrorhandlerInUpdateWeather() {
        // Given:
        let location = ""
        let expect = expectation(description: "wait for it")

        // When:
        weatherViewModel.errorHandler = { title, message in
            XCTAssertEqual(title, "Erreur")
            XCTAssertEqual(message, "Localisation inconnue...")
            expect.fulfill()
        }
        weatherViewModel.updateWeather(location)

        // Then:
        wait(for: [expect], timeout: 5)
    }

    func testUpdateWeatherWithAnErrorInWeatherClient() {
        // Given:
        let location = "Paris"
        let geolocationService = GeolocationService()
        let weatherViewModel = WeatherViewModel(
            geolocationService: geolocationService
        )
        let expect = expectation(description: "wait for it")

        // When:
        weatherViewModel.errorHandler = { title, message in
            XCTAssertEqual(title, "Erreur")
            XCTAssertEqual(message, "Météo indisponible pour le moment...")
            expect.fulfill()
        }
        weatherViewModel.updateWeather(location)

        // Then:
        wait(for: [expect], timeout: 5)
    }
}
