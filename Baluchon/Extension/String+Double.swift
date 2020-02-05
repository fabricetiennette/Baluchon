//
//  String+Double.swift
//  Baluchon
//
//  Created by Fabrice Etiennette on 23/01/2020.
//  Copyright © 2020 Fabrice Etiennette. All rights reserved.
//

import Foundation

extension String {
    static let numberFormatter = NumberFormatter()
    var doubleValue: Double {
        String.numberFormatter.decimalSeparator = "."
        if let result =  String.numberFormatter.number(from: self) {
            return result.doubleValue
        } else {
            String.numberFormatter.decimalSeparator = ","
            if let result = String.numberFormatter.number(from: self) {
                return result.doubleValue
            }
        }
        return 0
    }
}
