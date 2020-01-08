//
//  TodayViewModel.swift
//  Baluchon
//
//  Created by Fabrice Etiennette on 27/12/2019.
//  Copyright © 2019 Fabrice Etiennette. All rights reserved.
//

import Foundation
import UIKit

class TodayViewModel {
    var currencyValues: [Double] = []
    var currentForcast: [Currently] = []
    var rateHandler: (_ dollarLabelText: String?, _ poundLabelText: String?) -> Void = { _, _ in }
    var weatherHandler: (_ minTempLabelText: String?, _ maxTempLabelText: String?, _ temperatureLabelText: String?, _ summaryLabelText: String?) -> Void = { _, _, _, _  in }
    private let todayDate = Date()
    private let shortDateFormat = "EEEE"
    private let longDateFormat = "EEEE dd MMMM"

    static var currentPlace: String!
}

extension TodayViewModel {
    var todayDayLabelText: String {
        return todayDate.formatted(dateFormat: shortDateFormat)
    }

    var dateUILabelText: String {
        return todayDate.formatted(dateFormat: longDateFormat)
    }

    func getRate() {
        let currencyClient = CurrencyClient()
        currencyClient.getExchangeRate { [weak self] ( _, currencyValues, error) in
            guard let me = self else { return }
            me.currencyValues = currencyValues
            let dollar = currencyValues.first
            let dollarLabelText = dollar?.roundToDecimalAndConvertToString(2)
            let pound = currencyValues.last
            let poundLabelText = pound?.roundToDecimalAndConvertToString(2)
            me.rateHandler(dollarLabelText, poundLabelText)
            if let error = error {
                print(error)
            }
        }
    }

    func getCurrentWeather(latitude: Double, longitude: Double) {
        let weatherRest = WeatherClient()
        weatherRest.getCurrentWeather(latitude: latitude, longitude: longitude) { [weak self]( forcastData, currentForcast, error) in
            guard let me = self else { return }
            guard let tempForcast = currentForcast.first?.temperature else { return }
            let temperature = String("\(Int(tempForcast))°")
            let iconSummary = currentForcast.first?.icon
            guard let minTemp = forcastData.first?.temperatureMin else { return }
            guard let maxTemp = forcastData.first?.temperatureMax else { return }
            let minTemperature = String(Int(minTemp))
            let maxTemperature = String(Int(maxTemp))
            me.weatherHandler(minTemperature, maxTemperature, temperature, iconSummary)
            if let error = error {
                print(error)
            }
        }
    }
}
