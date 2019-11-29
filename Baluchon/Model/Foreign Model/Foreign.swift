//
//  Foreign.swift
//  Baluchon
//
//  Created by Fabrice Etiennette on 28/11/2019.
//  Copyright © 2019 Fabrice Etiennette. All rights reserved.
//

import Foundation

class Exchange {

    var myCurrency: [String] = []
    var myValues: [Double] = []

    private var rateSession: URLSession   // Stock a URLSessions
    private var task: URLSessionDataTask? // Stock a URLSessionsDataTask

    init(rateSession: URLSession = URLSession(configuration: .default)) {
        self.rateSession = rateSession
    }

    private let key = valueForAPIKey(named: "fixerApiKey")

    func getExchangeRate(callback: @escaping (Bool) -> Void ) {
        let url = URL(string: "http://data.fixer.io/api/latest?access_key=\(key)")

        task?.cancel()
        task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
            DispatchQueue.main.async {
                guard let data = data, error == nil else {
                    callback(false)
                    return
                }
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    callback(false)
                    return
                }
                guard let myJson = try? JSONDecoder().decode(Currency.self, from: data) else {
                    callback(false)
                    return
                }
                for (key, value) in Array(myJson.rates.sorted(by: { $0.0 < $1.0})) {
                    self.myCurrency.append(key)
                    self.myValues.append(value)
                }
                callback(true)
            }
        }
        task?.resume()
    }
}
