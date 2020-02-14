//
//  NetWorkError.swift
//  Baluchon
//
//  Created by Fabrice Etiennette on 14/02/2020.
//  Copyright © 2020 Fabrice Etiennette. All rights reserved.
//

import Foundation

enum NetWorkError: Error {
    case badUrl
    case noData
    case jsonError
}
