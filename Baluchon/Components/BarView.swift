//
//  BarView.swift
//  Baluchon
//
//  Created by Fabrice Etiennette on 31/01/2020.
//  Copyright © 2020 Fabrice Etiennette. All rights reserved.
//

import UIKit

@IBDesignable
class BarView: UIView {
    override func layoutSubviews() {
        super.layoutSubviews()
        updateStyle()
    }
}

private extension BarView {
    func updateStyle() {
       roundCorners([.bottomLeft, .bottomRight], radius: 15)
    }
}
