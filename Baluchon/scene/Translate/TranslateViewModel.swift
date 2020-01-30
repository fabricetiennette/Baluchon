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
        translateClient.getTranslatedText(translationBody) { (translatedText, error) in
            if error != nil {
                self.errorHandler(L10n.Localizable.error, L10n.Localizable.errorfound)
            } else {
                self.translatedTextHandler(translatedText)
            }
        }
    }

}
