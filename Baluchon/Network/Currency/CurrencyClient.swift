//
//  CurrencyClient.swift
//  Baluchon
//
//  Created by Fabrice Etiennette on 28/11/2019.
//  Copyright © 2019 Fabrice Etiennette. All rights reserved.
//

import Foundation
import Moya

class CurrencyClient {

    let provider: MoyaProvider<CurrencyAPI>

    init(provider: MoyaProvider<CurrencyAPI> = .init()) {
        self.provider = provider
    }

    func getExchangeRate(callback: @escaping ( _ myCurrency: [String], _ myValues: [Double], _ error: Error?) -> Void) {
        provider.request(.getRattes) { result in
            switch result {
            case .success(let response):
                do {
                    let rateResponse = try response.map(Currency.self)
                    var myCurrency = [String]()
                    var myValues = [Double]()
                    for (key, value) in Array(rateResponse.rates.sorted(by: { $0.0 < $1.0})) {
                        myCurrency.append(key)
                        myValues.append(value)
                    }
                    callback(myCurrency, myValues, nil)
                } catch {
                    callback([], [], error)
                }
            case .failure(let error):
                callback([], [], error)
            }
        }
    }
}
