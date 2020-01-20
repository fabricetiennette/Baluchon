//
//  WeatherViewModel.swift
//  Baluchon
//
//  Created by Fabrice Etiennette on 26/12/2019.
//  Copyright © 2019 Fabrice Etiennette. All rights reserved.
//

import Foundation
import UIKit

class WeatherViewModel {

    private let weatherRest = WeatherClient()
    private let geolocationService: GeolocationService

    var currentPlace = ""
    var backgroundViewHandler: (_ currentIcon: String) -> Void = {_ in }
    var forcastData: [DayData] = []
    var currentForcast: [Currently] = [] {
        didSet {
            if let currentIcon = currentForcast.first?.icon {
                backgroundViewHandler(currentIcon)
            }
        }
    }

    init(geolocationService: GeolocationService = .init()) {
        self.geolocationService = geolocationService
    }
}

extension WeatherViewModel {
    var location: String {
        if currentPlace.isEmpty {
            let currentLocation = GeolocationService.currentLocation
            return currentLocation
        } else {
            return currentPlace
        }
    }

    func updateWeather(_ location: String, _ tableView: UITableView) {
        geolocationService.updateWeatherForLocation(location) { (placemark, error) in
            self.currentPlace = location
            if error == nil {
                if let location = placemark?.first?.location {
                    self.getCurrentWeather(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude, tableView: tableView)
                }
            }
        }
    }

    func getCurrentWeather(latitude: Double, longitude: Double, tableView: UITableView) {
        weatherRest.getCurrentWeather(latitude: latitude, longitude: longitude) { [weak self] (forcastData, currentForcast, error) in
            guard let me = self else { return }
            me.forcastData = forcastData
            me.currentForcast = currentForcast
            DispatchQueue.main.async {
                tableView.reloadData()
            }
            if let error = error {
                print(error)
            }
        }
    }
}
