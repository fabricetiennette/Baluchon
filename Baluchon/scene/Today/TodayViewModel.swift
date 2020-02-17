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
    var weatherHandler: (_ weather: WeatherDetails) -> Void = { _  in }
    var locationHandler: (_ location: String?) -> Void = { _  in }
    private let todayDate = Date()
    private let shortDateFormat = "EEEE"
    private let longDateFormat = "EEEE dd MMMM"
    private let geolocationService: GeolocationService
    private let currencyClient: CurrencyClient
    private let weatherClient: WeatherClient

    init(
        geolocationService: GeolocationService = .init(),
        currencyClient: CurrencyClient = .init(),
        weatherClient: WeatherClient = .init()
    ) {
        self.geolocationService = geolocationService
        self.currencyClient = currencyClient
        self.weatherClient = weatherClient
    }
}

extension TodayViewModel {
    var todayDayLabelText: String {
        return todayDate
            .formatted(dateFormat: shortDateFormat)
            .capitalized
    }

    var dateUILabelText: String {
        return todayDate
            .formatted(dateFormat: longDateFormat)
            .capitalized
    }

    func updateweather() {
        guard let location = geolocationService.location?.first else { return }
        geolocationService.reverseGeocodeLocation(location) { (placemark, error) in
            if let location = placemark?.first?.locality {
                self.locationHandler(location)
                self.geolocationService.updateWeatherForLocation(location) { (placemark, error) in
                    if error == nil, let location = placemark?.first?.location {
                        self.getCurrentWeather(
                            latitude: location.coordinate.latitude,
                            longitude: location.coordinate.longitude
                        )
                    }
                }
            } else {
                self.errorHandler(L10n.Localizable.error, L10n.Localizable.geolocationerror)
            }
        }
    }

    func getRate() {
        currencyClient.getExchangeRate { [weak self] result in
            guard let me = self else { return }
            switch result {
            case .success(let currency):
                for (_, value) in Array(currency.rates.sorted(by: {$0.0 < $1.0})) {
                    me.currencyValues.append(value)
                }
                let pound = me.currencyValues.first
                let poundLabelText = pound?.roundToDecimalAndConvertToString(2)
                let dollar = me.currencyValues.last
                let dollarLabelText = dollar?.roundToDecimalAndConvertToString(2)
                me.rateHandler(poundLabelText, dollarLabelText)
            case .failure:
                me.errorHandler(L10n.Localizable.error, L10n.Localizable.rateunknown)
            }
        }
    }

    func getCurrentWeather(latitude: Double, longitude: Double) {
        weatherClient.getWeather(latitude: latitude, longitude: longitude) { [weak self] result in
            guard let me = self else { return }
            switch result {
            case .success(let weatherRest):
                let first = weatherRest.list.first
                guard let temperature = first?.main.temp.toTemperatureWithDegreeUnit,
                    let summary = first?.weather.first?.weatherDescription.capitalized,
                    let minTemperature = first?.main.tempMin.toTemperatureWithoutDegreeUnit,
                    let maxTemperature = first?.main.tempMax.toTemperatureWithoutDegreeUnit
                    else { return }
                let weatherDetails = WeatherDetails(
                    minTemperature: minTemperature,
                    maxTemperature: maxTemperature,
                    temperature: temperature,
                    iconSummary: summary
                )
                me.weatherHandler(weatherDetails)
            case .failure:
                me.errorHandler(L10n.Localizable.error, L10n.Localizable.weatherunknown)
            }
        }
    }
}
