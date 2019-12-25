//
//  WeatherAPI.swift
//  Baluchon
//
//  Created by Fabrice Etiennette on 25/12/2019.
//  Copyright © 2019 Fabrice Etiennette. All rights reserved.
//

import Foundation
import Moya

enum WeatherAPI {
    static private let weatherKey = valueForAPIKey(named: "darkSkyApiKey")

    case weather(Weather)
}

extension WeatherAPI: TargetType {
    var baseURL: URL {
        return URL(safeString: "https://api.darksky.net")
    }

    var path: String {
        switch self {
        case .weather(let weather):
            return "/forecast/\(WeatherAPI.weatherKey)/\(weather.latitude),\(weather.longitude)"
        }
    }

    var method: Moya.Method {
        switch self {
        case .weather:
            return .get
        }
    }

    var sampleData: Data {
        return Data()
    }

    var task: Task {
        switch self {
        case .weather(let weather):
            let bodyParameters = ["lang": weather.lang, "units": weather.units]
            return .requestParameters(parameters: bodyParameters, encoding: URLEncoding.default)
        }
    }

    var headers: [String: String]? {
        return [:]
    }

    var validationType: ValidationType {
        return .successCodes
    }

    public var authorizationType: AuthorizationType {
        return .none
    }
}
