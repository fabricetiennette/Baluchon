//
//  FakeResponseData.swift
//  Baluchon
//
//  Created by Fabrice Etiennette on 15/02/2020.
//  Copyright © 2020 Fabrice Etiennette. All rights reserved.
//

import Foundation

class FakeResponseData {

static let responseOK = HTTPURLResponse(url: URL(string: "https://openclassrooms.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)!
static let responseKO = HTTPURLResponse(url: URL(string: "https://openclassrooms.com")!, statusCode: 500, httpVersion: nil, headerFields: nil)!

// Currency
class CurrencyError: Error {}
static let errorCurrency = CurrencyError()
static var CurrencyCorrectData: Data {
    let bundle = Bundle(for: FakeResponseData.self)
    let url = bundle.url(forResource: "Currency", withExtension: "json")
    let data = try! Data(contentsOf: url!)
    return data
}

// Weather
class WeatherError: Error {}
static let errorWeather = WeatherError()
static var weatherCorrectData: Data {
    let bundle = Bundle(for: FakeResponseData.self)
    let url = bundle.url(forResource: "Weather", withExtension: "json")
    let data = try! Data(contentsOf: url!)
    return data
}

// Translate
class TranslateError: Error {}
static let errorTranslate = TranslateError()
static var translateCorrectData: Data {
    let bundle = Bundle(for: FakeResponseData.self)
    let url = bundle.url(forResource: "Translate", withExtension: "json")
    let data = try! Data(contentsOf: url!)
    return data
}
