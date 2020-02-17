//
//  WeatherClient.swift
//  Baluchon
//
//  Created by Fabrice Etiennette on 14/12/2019.
//  Copyright © 2019 Fabrice Etiennette. All rights reserved.
//

import Foundation

class WeatherClient {

    private var task: URLSessionDataTask?
    private var weatherSession: URLSession
    private let weatherKey = valueForAPIKey(named: "openWeatherApiKey")

    init(weatherSession: URLSession = URLSession(configuration: .default)) {
        self.weatherSession = weatherSession
    }

    func getWeather(
        latitude: Double,
        longitude: Double,
        callback: @escaping (Result <WeatherData, Error>) -> Void
    ) {

        let path = "http://api.openweathermap.org/data/2.5/find?"
        let param = "lat=\(latitude)&lon=\(longitude)&cnt=1&units=metric&lang=fr&appid="
        guard let weatherUrl = URL(string: "\(path)\(param)\(weatherKey)") else { return }

        task?.cancel()
        task = weatherSession.dataTask(with: weatherUrl) { (data, response, error) in
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
                    let weather = try JSONDecoder().decode(WeatherData.self, from: data)
                    callback(.success(weather))
                } catch {
                    callback(.failure(NetWorkError.jsonError))
                }
            }
        }
        task?.resume()
    }
}
