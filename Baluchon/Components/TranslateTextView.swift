//
//  TranslateTextView.swift
//  Baluchon
//
//  Created by Fabrice Etiennette on 31/01/2020.
//  Copyright © 2020 Fabrice Etiennette. All rights reserved.
//

import UIKit

@IBDesignable
class TranslateTextView: UITextView {
    override func layoutSubviews() {
        super.layoutSubviews()
        updateStyle()
    }
}

private extension TranslateTextView {
    func updateStyle() {
        layer.borderColor = UIColor.lightGray.cgColor
        layer.borderWidth = 2
        layer.cornerRadius = 5
    }
}
