//
//  WeatherClientTests.swift
//  BaluchonTests
//
//  Created by Fabrice Etiennette on 05/02/2020.
//  Copyright © 2020 Fabrice Etiennette. All rights reserved.
//

import XCTest
import Moya
@testable import Baluchon

class WeatherClientTests: XCTestCase {
    private lazy var stubProvider: MoyaProvider<WeatherAPI> = {
        return .init(stubClosure: MoyaProvider.immediatelyStub)
    }()

    var weatherClient: WeatherClient!

    override func setUp() {
        super.setUp()
        weatherClient = WeatherClient(provider: stubProvider)
    }

    override func tearDown() {
        weatherClient = nil
        super.tearDown()
    }

    func testWeatherClient() {
        //Given:
        let latitude = 37.8267
        let longitude = -122.4233
        let expect = expectation(description: "Gettin weather")

        //When:
        weatherClient.getCurrentWeather(latitude: latitude, longitude: longitude) { (daily, currently, error) in
            let currentWeather = currently.first

            XCTAssertEqual(currentWeather?.summary, "Ciel Dégagé")
            XCTAssertEqual(currentWeather?.icon, "clear-night")
            XCTAssertEqual(currentWeather?.temperature, 10.78)

            XCTAssertEqual(daily[0].summary, "Pluie faible dans la matinée.")
            XCTAssertEqual(daily[1].icon, "partly-cloudy-day")
            XCTAssertEqual(daily[2].time, 1580198400)
            XCTAssertEqual(daily[2].summary, "Ciel couvert toute la journée.")
            XCTAssertEqual(daily[3].temperatureMin, 7.75)
            XCTAssertEqual(daily[5].sunriseTime, 1580483760)
            XCTAssertEqual(daily[7].temperatureMax, 14.56)

            XCTAssertEqual(error?.localizedDescription, nil)
            expect.fulfill()
        }

        // Then:
        wait(for: [expect], timeout: 3)
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
        weatherClient = WeatherClient(provider: stubbingProvider)
        let expect = expectation(description: "Gettin weather")

        // When:
        weatherClient.getCurrentWeather(latitude: 37.8267, longitude: -122.4233) { (_, _, error) in
            XCTAssertNotNil(error)
            expect.fulfill()
        }

        // Then:
        wait(for: [expect], timeout: 3)
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
        weatherClient = WeatherClient(provider: stubbingProvider)
        let expect = expectation(description: "Gettin weather")

        // When:
        weatherClient.getCurrentWeather(latitude: 37.8267, longitude: -122.4233) { (daily, currently, error) in
            XCTAssertNil(currently.first?.icon)
            XCTAssertNil(daily.first?.summary)
            XCTAssertNotNil(error)
            expect.fulfill()
        }

        // Then:
        wait(for: [expect], timeout: 3)
    }
}
