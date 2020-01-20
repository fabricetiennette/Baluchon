//
//  CurrencyViewModel.swift
//  Baluchon
//
//  Created by Fabrice Etiennette on 27/12/2019.
//  Copyright © 2019 Fabrice Etiennette. All rights reserved.
//

import Foundation
import UIKit

class CurrencyViewModel {
    private let currencyClient: CurrencyClient
    var myCurrency: [String] = []
    var myValues: [Double] = []

    init(currencyClient: CurrencyClient = .init()) {
        self.currencyClient = currencyClient
    }

    func getRate(callback: @escaping () -> Void) {
        currencyClient.getExchangeRate { [weak self] (myCurrency, myValues, error) in
            guard let me = self else { return }
            me.myCurrency = myCurrency
            me.myValues = myValues
            callback()
            if let error = error {
                print(error)
            }
        }
    }
}
