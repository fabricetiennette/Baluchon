//
//  WeatherViewModel.swift
//  Baluchon
//
//  Created by Fabrice Etiennette on 26/12/2019.
//  Copyright © 2019 Fabrice Etiennette. All rights reserved.
//

import Foundation

class WeatherViewModel {

    private let weatherClient: WeatherClient
    private let geolocationService: GeolocationService

    private var currentPlace = ""
    var errorHandler: (_ title: String, _ message: String) -> Void = { _, _ in }
    var weatherHandler: (_ weather: WeatherDetails) -> Void = { _  in }

    init(
        geolocationService: GeolocationService = .init(),
        weatherClient: WeatherClient = .init()
    ) {
        self.geolocationService = geolocationService
        self.weatherClient = weatherClient
    }
}

extension WeatherViewModel {
    var location: String {
        if currentPlace.isEmpty {
            let currentLocation = GeolocationService.currentLocation
            return currentLocation
        }
        return currentPlace
    }

    func updateWeather(_ location: String) {
        geolocationService.updateWeatherForLocation(location) { (placemark, error) in
            self.currentPlace = location
            if let location = placemark?.first?.location {
                self.getCurrentWeather(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            }
            if error != nil {
                self.errorHandler("Erreur", "Localisation inconnue…")
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
                me.errorHandler("Erreur", "Météo indisponible pour le moment…")
            }
        }
    }
}
