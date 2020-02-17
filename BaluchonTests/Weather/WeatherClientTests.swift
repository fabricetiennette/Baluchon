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

    let latitude = 37.773972
    let longitude = -122.431297

    func testWeatherDataError() {
        // Given:
        let weatherClient = WeatherClient(weatherSession: URLSessionFake(data: nil, response: nil, error: FakeResponseData.errorWeather))
        let expect = expectation(description: "Wait for error to appear.")

        // When:
        weatherClient.getWeather(latitude: latitude, longitude: longitude) { result in
            if case .failure(let error) = result {
                XCTAssertNotNil(error)
                expect.fulfill()
            }
        }

        // Then:
        wait(for: [expect], timeout: 2)
    }

    func testWeatherResponseError() {
        // Given:
        let weatherClient = WeatherClient(weatherSession: URLSessionFake(data: FakeResponseData.weatherCorrectData, response: FakeResponseData.responseKO, error: nil))
        let expect = expectation(description: "Wait for error to appear.")

        // When:
        weatherClient.getWeather(latitude: latitude, longitude: longitude) { result in
            if case .failure(let error) = result {
                XCTAssertNotNil(error)
                expect.fulfill()
            }
        }

        // Then:
        wait(for: [expect], timeout: 2)
    }

    func testWeatherInSanFrancisco() {
        // Given:
        let weatherClient = WeatherClient(weatherSession: URLSessionFake(data: FakeResponseData.weatherCorrectData, response: FakeResponseData.responseOK, error: nil))
        var city: String?
        var cityTemperature: Double?
        let expect = expectation(description: "Wait for weather in San Francisco")

        // When:
        weatherClient.getWeather(latitude: latitude, longitude: longitude) { result in
            if case .success(let weather) = result {
                city = weather.list.first?.name
                cityTemperature = weather.list.first?.main.temp
                XCTAssertEqual(city, "San Francisco")
                XCTAssertEqual(cityTemperature, 8.3)
                expect.fulfill()
            }
        }

        // Then:
        wait(for: [expect], timeout: 2)
    }

    func testWeatherJsonError() {
        // Given:
        let weatherClient = WeatherClient(weatherSession: URLSessionFake(data: FakeResponseData.incorrectData, response: FakeResponseData.responseOK, error: nil))
        let expect = expectation(description: "Wait for error to appear.")

        // When:
        weatherClient.getWeather(latitude: latitude, longitude: longitude) { result in
            if case .failure(let error) = result {
                XCTAssertNotNil(error)
                expect.fulfill()
            }
        }

        // Then:
        wait(for: [expect], timeout: 2)
    }
}
