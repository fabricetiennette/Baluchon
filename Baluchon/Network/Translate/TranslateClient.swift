//
//  TranslateClient.swift
//  Baluchon
//
//  Created by Fabrice Etiennette on 26/11/2019.
//  Copyright © 2019 Fabrice Etiennette. All rights reserved.
//

import Foundation
import Moya

class TranslateClient {

    private let provider = MoyaProvider<TranslateAPI>()

    func getTranslatedText(_ translationBody: Translate, callback: @escaping ( _ translatedText: String?, _ error: Error?) -> Void) {
        provider.request(.translate(translationBody)) { result in

          switch result {
          case .success(let response):
            do {
                let translateResponse = try response.map(TranslateResponse.self)
                let translateData = translateResponse.data
                let translationText = translateData.translations[0]
                callback(translationText.translatedText, nil)
            } catch {
                callback(nil, error)
            }
          case .failure (let error):
            callback(nil, error)
          }
        }
    }
}
