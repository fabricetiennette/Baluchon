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
    private let translate = TranslateClient()

    func doTranslation(translationBody: Translate, text: UILabel) {
        translate.getTranslatedText(translationBody) { (translatedText, error) in
            text.text = translatedText
            if let error = error {
                print(error)
            }
        }
    }

}
