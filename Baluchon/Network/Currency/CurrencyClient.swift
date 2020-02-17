//
//  CurrencyClient.swift
//  Baluchon
//
//  Created by Fabrice Etiennette on 28/11/2019.
//  Copyright © 2019 Fabrice Etiennette. All rights reserved.
//

import Foundation

class CurrencyClient {

    private var task: URLSessionDataTask?
    private var currencySession: URLSession
//    private let currencyKey = valueForAPIKey(named: "fixerApiKey")

    init(currencySession: URLSession = URLSession(configuration: .default)) {
        self.currencySession = currencySession
    }

    func getExchangeRate(callback: @escaping (Result<Currency, Error>) -> Void) {

        guard let currencyKey = getEnvironmentVar("fixerApiKey") else { return }
        let baseURL = "http://data.fixer.io"
        let path = "/api/latest?"
        let param = "access_key=\(currencyKey)&base=EUR&symbols=GBP,USD"
        guard let currencyURL = URL(string: "\(baseURL)\(path)\(param)") else { return }

        task?.cancel()
        task = currencySession.dataTask(with: currencyURL) { (data, response, error) in
            DispatchQueue.main.async {

                guard let data = data, error == nil else {
                    callback(.failure(NetWorkError.noData))
                    return
                }

                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    callback(.failure(NetWorkError.badUrl))
                    return
                }

                do {
                    let currencyResponse = try JSONDecoder().decode(Currency.self, from: data)
                    callback(.success(currencyResponse))
                } catch {
                    callback(.failure(NetWorkError.jsonError))
                }
            }
        }
        task?.resume()
    }
}
