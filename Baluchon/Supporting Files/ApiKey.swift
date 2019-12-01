//
//  ApiKey.swift
//  Baluchon
//
//  Created by Fabrice Etiennette on 27/11/2019.
//  Copyright © 2019 Fabrice Etiennette. All rights reserved.
//

import Foundation

func valueForAPIKey(named keyname: String) -> AnyObject {
  let filePath = Bundle.main.path(forResource: "ApiKeys", ofType: "plist")
  let plist = NSDictionary(contentsOfFile: filePath!)
  let value = (plist?.object(forKey: keyname))! as AnyObject
  return value
}
