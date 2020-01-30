//
//  Date+Formatter.swift
//  Baluchon
//
//  Created by Lilian on 30/12/2019.
//  Copyright © 2019 Fabrice Etiennette. All rights reserved.
//

import Foundation

private let dateFormatter = DateFormatter()

extension Date {
    func formatted(
        dateFormat: String = "EEEE"
    ) -> String {
        dateFormatter.dateFormat = dateFormat
        return dateFormatter.string(from: self)
    }
}
