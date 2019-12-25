//
//  Currency.swift
//  Baluchon
//
//  Created by Fabrice Etiennette on 29/11/2019.
//  Copyright © 2019 Fabrice Etiennette. All rights reserved.
//

import Foundation

struct Currency: Decodable {
    let rates: [String: Double]
}
