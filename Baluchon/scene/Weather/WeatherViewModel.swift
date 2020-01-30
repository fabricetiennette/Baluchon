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

    var currentPlace = ""
    var backgroundViewHandler: (_ currentIcon: String) -> Void = {_ in }
    var reloadHandler: () -> Void = {}
    var errorHandler: (_ title: String, _ message: String) -> Void = { _, _ in }
    var forcastData: [DayData] = []
    var currentForcast: [Currently] = [] {
        didSet {
            if let currentIcon = currentForcast.first?.icon {
                backgroundViewHandler(currentIcon)
            }
        }
    }

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
        while currentPlace.isEmpty {
            let currentLocation = GeolocationService.currentLocation
            return currentLocation
        }
        return currentPlace
    }

    func updateWeather(_ location: String) {
        geolocationService.updateWeatherForLocation(location) { (placemark, error) in
            self.currentPlace = location
            if error == nil {
                if let location = placemark?.first?.location {
                    self.getCurrentWeather(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
                }
            } else {
                self.errorHandler(L10n.Localizable.error, L10n.Localizable.unknownlocation)
            }
        }
    }

    func getCurrentWeather(latitude: Double, longitude: Double) {
        weatherClient.getCurrentWeather(latitude: latitude, longitude: longitude) { [weak self] (forcastData, currentForcast, error) in
            guard let me = self else { return }
            me.forcastData = forcastData
            me.currentForcast = currentForcast
            DispatchQueue.main.async {
                me.reloadHandler()
            }
            if error != nil {
                me.errorHandler(L10n.Localizable.error, L10n.Localizable.weatherunknown)
            }
        }
    }
}
