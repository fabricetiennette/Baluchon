//
//  WeatherViewModelTests.swift
//  BaluchonTests
//
//  Created by Fabrice Etiennette on 28/01/2020.
//  Copyright © 2020 Fabrice Etiennette. All rights reserved.
//

import XCTest
import Moya
@testable import Baluchon

class WeatherViewModelTests: XCTestCase {
    private lazy var stubProvider: MoyaProvider<WeatherAPI> = {
           return .init(stubClosure: MoyaProvider.immediatelyStub)
       }()

    var tableView: UITableView!

    var weatherCell: WeatherCell!
    var weatherClient: WeatherClient!
    var weatherViewModel: WeatherViewModel!
    var geolocationService: GeolocationService!
    var weatherViewController: WeatherTableViewController!

    override func setUp() {
        weatherClient = WeatherClient(provider: stubProvider)
        weatherViewModel = WeatherViewModel()
        geolocationService = GeolocationService()
        weatherViewController = WeatherTableViewController()
        weatherCell = WeatherCell()
    }

    override func tearDown() {
        weatherCell = nil
        weatherViewController = nil
        weatherViewModel = nil
        weatherClient = nil
        geolocationService = nil
        super.tearDown()
    }

//    func testLocationUpdate() {
//        // Given:
//        let newLocation = "Los Angeles"
//        let secondLocation = ""
//        let currentLocation = GeolocationService.currentLocation
//
//        // When:
//        weatherViewModel.currentPlace = newLocation
//        let location = weatherViewModel.location.capitalized
//
//        weatherViewModel.currentPlace = secondLocation
//        let locationTwo = weatherViewModel.location.capitalized
//
//        // Then:
//        XCTAssertEqual(location, "Los Angeles")
//        XCTAssertEqual(locationTwo, currentLocation)
//    }

    func testErrorHandler() {
        let expect = expectation(description: "wait for it")
        let title = "Erreur"

        weatherViewModel.errorHandler = { titleText, messageText in
            XCTAssertEqual(titleText, title)
            expect.fulfill()
        }
        weatherViewModel.errorHandler("Erreur", "Unknown location...")
        wait(for: [expect], timeout: 5)
    }
}
