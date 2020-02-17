//
//  GeoLocationStub.swift
//  Baluchon
//
//  Created by Fabrice Etiennette on 16/02/2020.
//  Copyright © 2020 Fabrice Etiennette. All rights reserved.
//

import Foundation
import CoreLocation
@testable import Baluchon

enum ResponseError: Error {
    case unknownError
}

class GeoLocationStub: GeolocationService {

    override var location: [CLLocation]? {
        get { return [CLLocation(latitude: 37.773972, longitude: -122.431297)] }
        set { super.location = newValue }
    }

    override func reverseGeocodeLocation(
        _ locations: CLLocation?,
        completionHandler: @escaping ([CLPlacemark]?, Error?) -> Void
    ) {
        let error = ResponseError.unknownError
        completionHandler(nil, error)
    }
}

class TodayGeoLocationStub: GeolocationService {

    override var location: [CLLocation]? {
        get { return [CLLocation(latitude: 37.773972, longitude: -122.431297)] }
        set { super.location = newValue }
    }
}

class WeatherGeoLocationStub: GeolocationService {

    override func updateWeatherForLocation(_ location: String, completionHandler: @escaping ([CLPlacemark]?, Error?) -> Void) {
        let error = ResponseError.unknownError
        completionHandler(nil, error)
    }
}
