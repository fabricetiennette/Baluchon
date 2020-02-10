//
//  CurrencyViewModel.swift
//  Baluchon
//
//  Created by Fabrice Etiennette on 27/12/2019.
//  Copyright © 2019 Fabrice Etiennette. All rights reserved.
//

import Foundation

class CurrencyViewModel {
    private let currencyClient: CurrencyClient
    var errorHandler: (_ title: String, _ message: String) -> Void = { _, _ in }
    var myCurrency: [String] = []
    var myValues: [Double] = []
    var activeCurrency: Double = 0

    init(currencyClient: CurrencyClient = .init()) {
        self.currencyClient = currencyClient
    }

    func getRate(callback: @escaping () -> Void) {
        currencyClient.getExchangeRate { [weak self] (myCurrency, myValues, error) in
            guard let me = self else { return }
            if error != nil {
                me.errorHandler(L10n.Localizable.error, L10n.Localizable.rateunknown)
            } else {
                me.myCurrency = myCurrency
                me.myValues = myValues
                callback()
            }
        }
    }
}
