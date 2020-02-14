//
//  TodayViewModelTests.swift
//  BaluchonTests
//
//  Created by Fabrice Etiennette on 24/01/2020.
//  Copyright © 2020 Fabrice Etiennette. All rights reserved.
//

//import XCTest
//import Moya
//import CoreLocation
//@testable import Baluchon
//
//enum ResponseError: Error {
//    case unknownError
//}
//
//class LocationStub: GeolocationService {
//
//       override var location: [CLLocation]? {
//           get { return [CLLocation(latitude: 37.8267, longitude: -122.4233)] }
//           set { super.location = newValue }
//       }
//   }
//
//class GeolocationServiceStub: GeolocationService {
//
//    override var location: [CLLocation]? {
//        get { return [CLLocation()] }
//        set { super.location = newValue }
//    }
//
//    override func reverseGeocodeLocation(
//        _ locations: CLLocation?,
//        completionHandler: @escaping ([CLPlacemark]?, Error?) -> Void
//    ) {
//        let error = ResponseError.unknownError
//        completionHandler(nil, error)
//    }
//}
//
//class TodayViewModelTests: XCTestCase {
//    private lazy var stubProvider: MoyaProvider<WeatherAPI> = {
//        return .init(stubClosure: MoyaProvider.immediatelyStub)
//    }()
//
//    var todayViewModel: TodayViewModel!
//
//    override func setUp() {
//        super.setUp()
//        let currencyClient = CurrencyClient()
//        let geolocationService = GeolocationService()
//        let weatherClient = WeatherClient(provider: stubProvider)
//        todayViewModel = TodayViewModel(
//            geolocationService: geolocationService,
//            currencyClient: currencyClient,
//            weatherClient: weatherClient
//        )
//    }
//
//    override func tearDown() {
//        todayViewModel = nil
//        super.tearDown()
//    }
//
//    func testDate() {
//        // Given:
//        let todayDate = Date()
//        let shortDateFormat = "EEEE"
//        let longDateFormat = "EEEE dd MMMM"
//        // When:
//        let currentDay = todayViewModel.todayDayLabelText
//        let currentDayResult = todayDate.formatted(dateFormat: shortDateFormat).capitalized
//        let currentLongFormatDay = todayViewModel.dateUILabelText
//        let currentLongFormatDayResult = todayDate.formatted(dateFormat: longDateFormat).capitalized
//        // Then:
//        XCTAssertEqual(currentDay, currentDayResult)
//        XCTAssertEqual(currentLongFormatDay, currentLongFormatDayResult)
//    }
//
//    func testExample() {
//        // Given:
//        let latitude = 37.8267
//        let longitude = -122.4233
//        let icon = "clear-night"
//        let temperature = "10°"
//        let temperatureMin = "10"
//        let temperatureMax = "14"
//        let expect = expectation(description: "getting data...")
//
//        // When:
//        todayViewModel.weatherHandler = { weather in
//            XCTAssertEqual(icon.capitalized, weather.iconSummary)
//            XCTAssertEqual(temperature, weather.temperature)
//            XCTAssertEqual(temperatureMax, weather.maxTemperature)
//            XCTAssertEqual(temperatureMin, weather.minTemperature)
//            expect.fulfill()
//        }
//        todayViewModel.getCurrentWeather(latitude: latitude, longitude: longitude)
//
//        // Then:
//        wait(for: [expect], timeout: 5)
//    }
//
//    func testUpdateWeather() {
//        // Given:
//        let currencyClientStub = CurrencyClientStub()
//        let weatherClient = WeatherClient(provider: stubProvider)
//        let geolocationService = GeolocationService()
//        let todayViewModel = TodayViewModel(
//            geolocationService: geolocationService,
//            currencyClient: currencyClientStub,
//            weatherClient: weatherClient
//        )
//        let expect = expectation(description: "Wait for errorHandler")
//
//        // When:
//        todayViewModel.errorHandler = { title, message in
//            expect.fulfill()
//        }
//
//        todayViewModel.getRate()
//
//        // Then:
//        wait(for: [expect], timeout: 3)
//    }
//
//    func testErrorLocation() {
//        // Given:
//        let currencyClient = CurrencyClient()
//        let weatherClient = WeatherClient(provider: stubProvider)
//        let geolocationServiceStub = GeolocationServiceStub()
//        let todayViewModel = TodayViewModel(
//            geolocationService: geolocationServiceStub,
//            currencyClient: currencyClient,
//            weatherClient: weatherClient
//        )
//        let expect = expectation(description: "Wait for errorHandler")
//
//        // When:
//        todayViewModel.errorHandler = { title, message in
//            expect.fulfill()
//        }
//        todayViewModel.updateweather()
//
//        // Then:
//        wait(for: [expect], timeout: 3)
//    }
//
//    func testUpdateWeatherWhenLocationIsSanFrancisco() {
//        // Given:
//        let icon = "clear-night"
//        let temperature = "10°"
//        let temperatureMin = "10"
//        let temperatureMax = "14"
//        let currencyClient = CurrencyClient()
//        let weatherClient = WeatherClient(provider: stubProvider)
//        let locationStub = LocationStub()
//        let todayViewModel = TodayViewModel(
//            geolocationService: locationStub,
//            currencyClient: currencyClient,
//            weatherClient: weatherClient
//        )
//        let expect = expectation(description: "Wait for errorHandler")
//
//        // When:
//        todayViewModel.locationHandler = { location in
//            XCTAssertEqual(location, "San Francisco")
//        }
//        todayViewModel.weatherHandler = { weather in
//            XCTAssertEqual(icon.capitalized, weather.iconSummary)
//            XCTAssertEqual(temperature, weather.temperature)
//            XCTAssertEqual(temperatureMax, weather.maxTemperature)
//            XCTAssertEqual(temperatureMin, weather.minTemperature)
//            expect.fulfill()
//        }
//        todayViewModel.updateweather()
//
//        // Then:
//        wait(for: [expect], timeout: 3)
//    }
//}
