//
//  TranslateAPI.swift
//  Baluchon
//
//  Created by Fabrice Etiennette on 25/12/2019.
//  Copyright © 2019 Fabrice Etiennette. All rights reserved.
//

import Foundation
import Moya

enum TranslateAPI {
    static private let googleKey = valueForAPIKey(named: "googleApiKey")

    case translate(Translate)
}

extension TranslateAPI: TargetType {
    var baseURL: URL {
        return URL(safeString: "https://translation.googleapis.com")
    }

    var path: String {
        switch self {
        case .translate:
            return "/language/translate/v2"
        }
    }

    var method: Moya.Method {
        switch self {
        case .translate:
            return .post
        }
    }

    var sampleData: Data {
        return Data()
    }

    var task: Task {
        switch self {
        case .translate(let translate):
            let bodyParameters = ["q": translate.text, "source": translate.source.rawValue, "target": translate.target.rawValue, "format": translate.format, "key": TranslateAPI.googleKey]
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
