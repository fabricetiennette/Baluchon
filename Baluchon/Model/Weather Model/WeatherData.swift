//
//  WeatherData.swift
//  Baluchon
//
//  Created by Fabrice Etiennette on 14/12/2019.
//  Copyright © 2019 Fabrice Etiennette. All rights reserved.
//

import Foundation

struct WeatherData: Decodable {
    let list: [List]
}

struct List: Decodable {
    let weather: [Weather]
    let main: Main
}

struct Main: Decodable {
    let temp, tempMin, tempMax: Double

    enum CodingKeys: String, CodingKey {
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case temp
    }
}

struct Weather: Decodable {
    let weatherDescription, icon: String?

    enum CodingKeys: String, CodingKey {
        case weatherDescription = "description"
        case icon
    }
}
