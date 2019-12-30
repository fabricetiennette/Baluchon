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

    var currentPlace: String!
    var backgroundViewHandler: (_ currentIcon: String) -> Void = {_ in }
    var forcastData: [DayData] = []
    var currentForcast: [Currently] = [] {
        didSet {
            if let currentIcon = currentForcast.first?.icon {
                backgroundViewHandler(currentIcon)
            }
        }
    }

//    func getCurrentWeather(latitude: Double, longitude: Double) {
//        weatherRest.getCurrentWeather(latitude: latitude, longitude: longitude) { [weak self] (forcastData, currentForcast, error) in
//            guard let me = self else { return }
//            me.forcastData = forcastData
//            me.currentForcast = currentForcast
//            if let error = error {
//                print(error)
//            }
//        }
//    }
}
