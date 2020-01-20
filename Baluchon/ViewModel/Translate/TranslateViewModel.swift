//
//  TranslateViewModel.swift
//  Baluchon
//
//  Created by Fabrice Etiennette on 27/12/2019.
//  Copyright © 2019 Fabrice Etiennette. All rights reserved.
//

import Foundation
import UIKit

class TranslateViewModel {
    private let translateClient: TranslateClient
    var translatedTextHandler: (_ translatedText: String?) -> Void = { _  in }

    init(translateClient: TranslateClient = .init()) {
        self.translateClient = translateClient
    }

    func doTranslation(translationBody: Translate) {
        translateClient.getTranslatedText(translationBody) { (translatedText, error) in
            self.translatedTextHandler(translatedText)
            if let error = error {
                print(error)
            }
        }
    }

}
