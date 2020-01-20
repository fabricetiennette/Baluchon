//
//  TodayViewModel.swift
//  Baluchon
//
//  Created by Fabrice Etiennette on 27/12/2019.
//  Copyright © 2019 Fabrice Etiennette. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

class TodayViewModel {
    var currencyValues: [Double] = []
    var currentForcast: [Currently] = []
    var rateHandler: (_ dollarLabelText: String?, _ poundLabelText: String?) -> Void = { _, _ in }
    var weatherHandler: (_ weather: Weather) -> Void = { _  in }
    var locationHandler: (_ location: String?) -> Void = { _  in }
    private let todayDate = Date()
    private let shortDateFormat = "EEEE"
    private let longDateFormat = "EEEE dd MMMM"
    private let geolocationService: GeolocationService

    init(geolocationService: GeolocationService = .init()) {
        self.geolocationService = geolocationService
    }
}

extension TodayViewModel {
    var todayDayLabelText: String {
        return todayDate.formatted(dateFormat: shortDateFormat)
    }

    var dateUILabelText: String {
        return todayDate.formatted(dateFormat: longDateFormat)
    }

    func updateweather() {
        guard let location = geolocationService.location?.first else { return }
        geolocationService.reverseGeocodeLocation(location) { (placemark, error) in
            if let location = placemark?.first?.locality {
                self.locationHandler(location)
                self.geolocationService.updateWeatherForLocation(location) { (placemark, error) in
                    if error == nil, let location = placemark?.first?.location {
                        self.getCurrentWeather(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
                    }
                }
            }
        }
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
            guard let me = self,
                let tempForcast = currentForcast.first?.temperature,
                let minTemp = forcastData.first?.temperatureMin,
                let maxTemp = forcastData.first?.temperatureMax
                else { return }

            let temperature = "\(Int(tempForcast))°"
            let iconSummary = currentForcast.first?.icon
            let minTemperature = "\(Int(minTemp))"
            let maxTemperature = "\(Int(maxTemp))"
            let weather = Weather(minTemperature: minTemperature, maxTemperature: maxTemperature, temperature: temperature, iconSummary: iconSummary)
            me.weatherHandler(weather)
            if let error = error {
                print(error)
            }
        }
    }
}

extension TodayViewModel {
    struct Weather {
        let minTemperature: String
        let maxTemperature: String
        let temperature: String
        let iconSummary: String?
    }
}
