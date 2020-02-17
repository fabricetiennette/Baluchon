//
//  ApiKeys.swift
//  Baluchon
//
//  Created by Fabrice Etiennette on 27/11/2019.
//  Copyright © 2019 Fabrice Etiennette. All rights reserved.
//

import Foundation

func valueForAPIKey(named keyname: String) -> String {
    guard let filePath = Bundle.main.path(forResource: "ApiKeys", ofType: "plist") else {
        fatalError("Fatal Error : ApiKeys.plist missing.")
    }
    let plist = NSDictionary(contentsOfFile: filePath)
    guard let apiKey = (plist?.object(forKey: keyname)) as? String,
        !apiKey.isEmpty else {
            fatalError("Missing Api Key for \(String(describing: plist))")
    }
    return apiKey
}
