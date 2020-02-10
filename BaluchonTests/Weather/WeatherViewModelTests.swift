//
//  WeatherViewModelTests.swift
//  BaluchonTests
//
//  Created by Fabrice Etiennette on 28/01/2020.
//  Copyright © 2020 Fabrice Etiennette. All rights reserved.
//

import XCTest
import Moya
import CoreLocation
@testable import Baluchon

class WeatherViewModelTests: XCTestCase {
    private lazy var stubProvider: MoyaProvider<WeatherAPI> = {
           return .init(stubClosure: MoyaProvider.immediatelyStub)
       }()

    var weatherViewModel: WeatherViewModel!

    override func setUp() {
        super.setUp()
        let geolocationService = GeolocationService()
        let weatherClient = WeatherClient(provider: stubProvider)
        weatherViewModel = WeatherViewModel(
            geolocationService: geolocationService,
            weatherClient: weatherClient
        )
    }

    override func tearDown() {
        weatherViewModel = nil
        super.tearDown()
    }

    func testNumberOfSection() {
        // Given:
        let numberOfSection = 2

        // When:
        let viewModelNumberOfSection = weatherViewModel.numberOfSections

        // Then:
        XCTAssertEqual(numberOfSection, viewModelNumberOfSection)
    }

    func testCurrentLocation() {
        // Given:
        var unknownLocation: String?

        // When:
        GeolocationService.currentLocation = "San Francisco"
        unknownLocation = weatherViewModel.location

        // Then:
        XCTAssertEqual(unknownLocation, "San Francisco")
    }

    func testCurrentLocationWhencCurrentPlaceIsNotEmpty() {
        // Given:
        let locationStub = LocationStub()
        let weatherClient = WeatherClient(provider: stubProvider)
        let weatherViewModel = WeatherViewModel(
            geolocationService: locationStub,
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
        XCTAssertFalse(weatherViewModel.forcastData.isEmpty)
        XCTAssertFalse(weatherViewModel.currentForcast.isEmpty)
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
        let weatherStub = WeatherStub()
        let geolocationService = GeolocationService()
        let weatherViewModel = WeatherViewModel(
            geolocationService: geolocationService,
            weatherClient: weatherStub
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
