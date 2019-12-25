//
//  URL+.swift
//  Baluchon
//
//  Created by Fabrice Etiennette on 25/12/2019.
//  Copyright © 2019 Fabrice Etiennette. All rights reserved.
//

import Foundation

extension URL {
    /// Non-optional initializer with better fail output
    public init(safeString string: String) {
        guard let instance = URL(string: string) else {
            fatalError("Unconstructable URL: \(string)")
        }
        self = instance
    }
}
