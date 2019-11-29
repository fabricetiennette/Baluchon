//
//  Translate.swift
//  Baluchon
//
//  Created by Fabrice Etiennette on 26/11/2019.
//  Copyright © 2019 Fabrice Etiennette. All rights reserved.
//

import Foundation

class Translate {
    private let url = URL(string: "https://translation.googleapis.com/language/translate/v2?")!
    private var translateSession: URLSession
    private var task: URLSessionDataTask?
    private let googleTranslateApiKey = valueForAPIKey(named: "googleApiKey")

    private var source: String = "fr"
    private var target: String = "en"

    init(translateSession: URLSession = URLSession(configuration: .default)) {
        self.translateSession = translateSession
    }

    // Modify source and target according to received index
    private func selectedLanguage(language: Int) {
        switch language {
        case 0:
            source = "source=fr"
            target = "en"
        case 1:
            source = "source=en"
            target = "fr"
        default: break
        }
    }

    // Create a request based on the received parameter
    private func createTranslateRequest(text: String, language: Int) -> URLRequest? {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let query: String = text
        selectedLanguage(language: language)

        let body = "q=\(query)" + "&\(source)" + "&target=\(target)" + "&format=text" + "&key=\(googleTranslateApiKey)"
        request.httpBody = body.data(using: .utf8)

        return request
    }

    // Send a request to the Google Translate API and return this response
    func translate(index: Int, text: String, callback: @escaping (Bool, String?) -> Void) {
        let request = createTranslateRequest(text: text, language: index)
        task?.cancel()
        task = translateSession.dataTask(with: request!) { (data, response, error) in
            DispatchQueue.main.async {
                guard let data = data, error == nil else {
                    callback(false, nil)
                    return
                }
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    callback(false, nil)
                    return
                }
                guard let responseJSON = try? JSONDecoder().decode(Translation.self, from: data),
                    let textTranslated = responseJSON.data.translations[0].translatedText else {
                        callback(false, nil)
                        return
                }
                callback(true, textTranslated)
            }
        }
        task?.resume()
    }
}
