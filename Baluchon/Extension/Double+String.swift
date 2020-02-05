//
//  Double+String.swift
//  Baluchon
//
//  Created by Fabrice Etiennette on 07/01/2020.
//  Copyright © 2020 Fabrice Etiennette. All rights reserved.
//

import Foundation

extension Double {
    func roundToDecimalAndConvertToString(_ fractionDigits: Int) -> String {
        let multiplier = pow(10, Double(fractionDigits))
        let roundedDecimal = Darwin.round(self * multiplier) / multiplier
        return String(roundedDecimal)
    }

    var toTemperatureWithDegreeUnit: String {
        return "\(Int(self))°"
    }

    var toTemperatureWithoutDegreeUnit: String {
        return "\(Int(self))"
    }
}
