//
//  TodayViewModel.swift
//  Baluchon
//
//  Created by Fabrice Etiennette on 27/12/2019.
//  Copyright © 2019 Fabrice Etiennette. All rights reserved.
//

import Foundation

class TodayViewModel {
    var currencyValues: [Double] = []
    var rateHandler: (_ poundLabelText: String?, _ dollarLabelText: String?) -> Void = { _, _ in }
    var errorHandler: (_ title: String, _ message: String) -> Void = { _, _ in }
    var weatherHandler: (_ weather: Weather) -> Void = { _  in }
    var locationHandler: (_ location: String?) -> Void = { _  in }
    private let todayDate = Date()
    private let shortDateFormat = "EEEE"
    private let longDateFormat = "EEEE dd MMMM"
    private let geolocationService: GeolocationService
    private let currencyClient: CurrencyClient
    private let weatherClient: WeatherClient

    init(
        geolocationService: GeolocationService,
        currencyClient: CurrencyClient,
        weatherClient: WeatherClient = .init()
    ) {
        self.geolocationService = geolocationService
        self.currencyClient = currencyClient
        self.weatherClient = weatherClient
    }
}

extension TodayViewModel {
    var todayDayLabelText: String {
        return todayDate.formatted(dateFormat: shortDateFormat).capitalized
    }

    var dateUILabelText: String {
        return todayDate.formatted(dateFormat: longDateFormat).capitalized
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
        currencyClient.getExchangeRate { [weak self] (_, currencyValues, error) in
            guard let me = self else { return }
            me.currencyValues = currencyValues
            let pound = currencyValues.first
            let poundLabelText = pound?.roundToDecimalAndConvertToString(2)
            let dollar = currencyValues.last
            let dollarLabelText = dollar?.roundToDecimalAndConvertToString(2)
            me.rateHandler(poundLabelText, dollarLabelText)
            if error != nil {
                me.errorHandler(L10n.Localizable.error, L10n.Localizable.rateunknown)
            }
        }
    }

    func getCurrentWeather(latitude: Double, longitude: Double) {
        weatherClient.getCurrentWeather(latitude: latitude, longitude: longitude) { [weak self] (forcastData, currentForcast, error) in
            guard let me = self,
                let tempForcast = currentForcast.first?.temperature,
                let minTemp = forcastData.first?.temperatureMin,
                let maxTemp = forcastData.first?.temperatureMax
                else { return }
            if error == nil {
                let temperature = "\(Int(tempForcast))°"
                let iconSummary = currentForcast.first?.icon.capitalized
                let minTemperature = "\(Int(minTemp))"
                let maxTemperature = "\(Int(maxTemp))"
                let weather = Weather(minTemperature: minTemperature, maxTemperature: maxTemperature, temperature: temperature, iconSummary: iconSummary)
                me.weatherHandler(weather)
            } else {
                me.errorHandler(L10n.Localizable.error, L10n.Localizable.weatherunknown)
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
