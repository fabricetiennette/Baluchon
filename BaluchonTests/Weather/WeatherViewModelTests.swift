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

class WeatherStub: WeatherClient {

    override func getCurrentWeather(
        latitude: Double, longitude: Double,
        callback: @escaping ([DayData], [Currently], Error?) -> Void
    ) {
        let error = ResponseError.unknownError
        callback([], [], error)
    }
}

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

    func testNumberOfRowInSectionWhenSectionIsZero() {
        // Given:
        let sectionZero = 0
        var newNumberOfSection: Int = 0
        let expect = expectation(description: "wait for it")

        // When:
        weatherViewModel.getCurrentWeather(latitude: 37.8267, longitude: -122.4233)
        newNumberOfSection = weatherViewModel.numberOfRowsInSection(in: sectionZero)
        XCTAssertEqual(newNumberOfSection, 1)
        expect.fulfill()

        // Then:
        wait(for: [expect], timeout: 2)
    }

    func testNumberOfRowInSectionWhenSectionIsTwo() {
        // Given:
        let sectionTwo = 1
        var newNumberOfSection: Int = 0
        let expect = expectation(description: "wait for it")

        // When:
        weatherViewModel.getCurrentWeather(latitude: 37.8267, longitude: -122.4233)
        newNumberOfSection = weatherViewModel.numberOfRowsInSection(in: sectionTwo)
        XCTAssertEqual(newNumberOfSection, 8)
        expect.fulfill()

        // Then:
        wait(for: [expect], timeout: 2)
    }

    func testHightForRowWithIndexpathSectionZero() {
        let indexPath = IndexPath(row: 0, section: 0)
        var hightForRow: CGFloat = 0
        let expect = expectation(description: "wait for it")

        weatherViewModel.getCurrentWeather(latitude: 37.8267, longitude: -122.4233)
        hightForRow = weatherViewModel.heightForRowAt(at: indexPath)
        XCTAssertEqual(hightForRow, 220)
        expect.fulfill()

        wait(for: [expect], timeout: 3)
    }

    func testHightForRowWithIndexpathSectionNotZero() {
        let indexPath = IndexPath(row: 1, section: 1)
        var hightForRow: CGFloat = 0
        let expect = expectation(description: "wait for it")

        weatherViewModel.getCurrentWeather(latitude: 37.8267, longitude: -122.4233)
        hightForRow = weatherViewModel.heightForRowAt(at: indexPath)
        XCTAssertEqual(hightForRow, 50)
        expect.fulfill()

        wait(for: [expect], timeout: 3)
    }
}
