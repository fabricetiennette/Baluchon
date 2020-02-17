//
//  TranslateClient.swift
//  Baluchon
//
//  Created by Fabrice Etiennette on 26/11/2019.
//  Copyright © 2019 Fabrice Etiennette. All rights reserved.
//

import Foundation

class TranslateClient {

    private var task: URLSessionDataTask?
    private var translateSession: URLSession
//    private let translateKey = valueForAPIKey(named: "googleApiKey")

    init(translateSession: URLSession = URLSession(configuration: .default)) {
        self.translateSession = translateSession
    }

    func getTranslatedText(
        _ translationBody: Translate,
        callback: @escaping (Result <TranslationText, Error>) -> Void
    ) {

        guard let text = translationBody.text.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return }
        guard let translateKey = getEnvironmentVar("googleApiKey") else { return }
        let baseURL = "https://translation.googleapis.com"
        let path = "/language/translate/v2?"
        let format = "&format=\(translationBody.format)"
        let key = "&key=\(translateKey)"
        let target = "&target=\(translationBody.target.rawValue)"
        let source = "&source=\(translationBody.source.rawValue)"
        let param = "q=\(text)\(source)\(target)\(format)\(key)"
        guard let translateURL = URL(string: "\(baseURL)\(path)\(param)") else { return }

        task?.cancel()
        task = translateSession.dataTask(with: translateURL) { (data, response, error) in
            DispatchQueue.main.async {

                guard let data = data, error == nil else {
                    callback(.failure(NetWorkError.noData))
                    return
                }

                guard let response = response as? HTTPURLResponse,
                    response.statusCode == 200 else {
                    callback(.failure(NetWorkError.badUrl))
                    return
                }

                do {
                    let translateRest = try JSONDecoder().decode(TranslateResponse.self, from: data)
                    let translateData = translateRest.data
                    let translationText = translateData.translations[0]
                    callback(.success(translationText))
                } catch {
                    callback(.failure(NetWorkError.jsonError))
                }
            }
        }
        task?.resume()
    }
}
