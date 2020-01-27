//
//  WeatherClient.swift
//  Baluchon
//
//  Created by Fabrice Etiennette on 14/12/2019.
//  Copyright © 2019 Fabrice Etiennette. All rights reserved.
//

import Foundation
import Moya

class WeatherClient {
    private let provider: MoyaProvider<WeatherAPI>

    init(provider: MoyaProvider<WeatherAPI> = .init()) {
        self.provider = provider
    }

    func getCurrentWeather(latitude: Double, longitude: Double, callback: @escaping (_ forecastArray: [DayData], _ currentArray: [Currently], _ error: Error?) -> Void) {
        provider.request(.weather(Weather(latitude: latitude, longitude: longitude))) { result in
            switch result {
            case .success(let response):
                do {
                    let weather = try response.map(WeatherResponse.self)
                    callback(weather.daily.data, [weather.currently], nil)
                } catch {
                    callback([], [], error)
                }
            case .failure(let error):
                callback([], [], error)
            }
        }
    }
}
