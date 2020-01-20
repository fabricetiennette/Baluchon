//
//  CurrencyAPI.swift
//  Baluchon
//
//  Created by Fabrice Etiennette on 08/12/2019.
//  Copyright © 2019 Fabrice Etiennette. All rights reserved.
//

import Moya
import Foundation

enum CurrencyAPI {
    static private let foreignKey = valueForAPIKey(named: "fixerApiKey")

    case getRattes
}

extension CurrencyAPI: TargetType {
    var baseURL: URL {
        return URL(safeString: "http://data.fixer.io")
    }

    var path: String {
        switch self {
        case .getRattes:
            return "/api/latest"
        }
    }

    var method: Moya.Method {
        switch self {
        case .getRattes:
            return .get
        }
    }

    var sampleData: Data {
        return Data()
    }

    var task: Task {
        switch self {
        case .getRattes:
            let bobyParameters = ["access_key": CurrencyAPI.foreignKey, "base": "EUR", "symbols": "GBP,USD"]
            return .requestParameters(parameters: bobyParameters, encoding: URLEncoding.default)
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
