//
//  Translate.swift
//  Baluchon
//
//  Created by Fabrice Etiennette on 12/12/2019.
//  Copyright © 2019 Fabrice Etiennette. All rights reserved.
//

import Foundation

struct Translate {
    let source: Language
    let target: Language
    let text: String
    let format = "text"

    init(source: Language, text: String) {
        self.source = source
        self.target = (source == .fr) ? .en : .fr
        self.text = text
    }
}
