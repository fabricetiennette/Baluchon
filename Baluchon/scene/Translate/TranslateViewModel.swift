//
//  TranslateViewModel.swift
//  Baluchon
//
//  Created by Fabrice Etiennette on 27/12/2019.
//  Copyright © 2019 Fabrice Etiennette. All rights reserved.
//

import Foundation

class TranslateViewModel {
    private let translateClient: TranslateClient
    var translatedTextHandler: (_ translatedText: String?) -> Void = { _  in }
    var errorHandler: (_ title: String, _ message: String) -> Void = { _, _ in }

    init(translateClient: TranslateClient = .init()) {
        self.translateClient = translateClient
    }

    func doTranslation(translationBody: Translate) {
        translateClient.getTranslatedText(translationBody) { result in
            switch result {
            case .success(let text):
                self.translatedTextHandler(text.translatedText)
            case .failure:
                self.errorHandler("Erreur", "Malheureusement une erreur c’est produite")
            }
        }
    }
}
