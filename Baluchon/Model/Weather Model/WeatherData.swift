//
//  WeatherData.swift
//  Baluchon
//
//  Created by Fabrice Etiennette on 14/12/2019.
//  Copyright © 2019 Fabrice Etiennette. All rights reserved.
//

import Foundation

struct WeatherResponse: Decodable {
    let currently: Currently
    let daily: Daily
}

struct Currently: Decodable {
    let summary: String
    let icon: String
    let temperature: Double
    let uvIndex: Double
    let humidity: Double
    let windSpeed: Double
    let visibility: Double
}

struct Daily: Decodable {
    let data: [DayData]
}

struct DayData: Decodable {
    let icon: String
    let summary: String
    let temperatureMax, temperatureMin: Double
    let temperatureHigh: Double
    let temperatureLow: Double
    let time: Double
    let precipIntensity: Double
    let precipProbability: Double // must be Double not Int
    let dewPoint, humidity, pressure, windSpeed: Double
    let sunriseTime, sunsetTime: Double
    let windGust, windBearing, cloudCover, uvIndex, visibility: Double
}
