//
//  UIView+.swift
//  Baluchon
//
//  Created by Fabrice Etiennette on 26/11/2019.
//  Copyright © 2019 Fabrice Etiennette. All rights reserved.
//

import UIKit

extension UIView {

    func rotateIt() {
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn, animations: { () -> Void in
            self.transform = CGAffineTransform(rotationAngle: .pi)
        })
        self.transform = CGAffineTransform.identity
    }
}
