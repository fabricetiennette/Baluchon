//
//  WeatherNetworkTests.swift
//  BaluchonTests
//
//  Created by Fabrice Etiennette on 24/01/2020.
//  Copyright © 2020 Fabrice Etiennette. All rights reserved.
//

//import XCTest
//import Moya
//@testable import Baluchon
//
//class WeatherNetworkTests: XCTestCase {
//    var provider = MoyaProvider<WeatherAPI>()
//    var weatherClient: WeatherClient!
//
//    override func setUp() {
//        // Put setup code here. This method is called before the invocation of each test method in the class.
//        weatherClient = WeatherClient()
//    }
//
//    override func tearDown() {
//        // Put teardown code here. This method is called after the invocation of each test method in the class.
//        weatherClient = nil
//        super.tearDown()
//    }

//    func testGetWeather() {
//        let latitude = 33.8688
//        let longitude = 151.2093
//        var currentForcast: [Currently] = []
//        let client = weatherClient.getCurrentWeather(latitude: latitude, longitude: longitude) { [weak self] (forcastData, currentForcast, error) in
//            guard let me = self,
//            let tempForcast = currentForcast.first?.temperature,
//            let minTemp = forcastData.first?.temperatureMin,
//            let maxTemp = forcastData.first?.temperatureMax
//            else { return }
//            if error == nil {
//                let temperature = "\(Int(tempForcast))°"
//                let iconSummary = currentForcast.first?.icon.capitalized
//                let minTemperature = "\(Int(minTemp))"
//                let maxTemperature = "\(Int(maxTemp))"
//                let weather = Weather(minTemperature: minTemperature, maxTemperature: maxTemperature, temperature: temperature, iconSummary: iconSummary)
//                me.weatherHandler(weather)
//            } else {
//                print("error")
//            }
//            
//        }
//        XCTAssertNotNil(client)
//    }
//}
