//
//  ShadowCardView.swift
//  Baluchon
//
//  Created by Lilian on 30/12/2019.
//  Copyright © 2019 Fabrice Etiennette. All rights reserved.
//

import UIKit

@IBDesignable
class ShadowCardView: UIView {
    override func layoutSubviews() {
        super.layoutSubviews()
        updateStyle()
    }
}

private extension ShadowCardView {
    func updateStyle() {
        layer.cornerRadius = 15
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize.zero
        layer.shadowOpacity = 0.8
        layer.shadowRadius = 5
    }
}
