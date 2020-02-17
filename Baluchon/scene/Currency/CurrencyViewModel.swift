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
        currencyClient.getExchangeRate { [weak self] result in
            guard let me = self else { return }
            switch result {
            case .success(let currency):
                for (key, value) in Array(currency.rates.sorted(by: {$0.0 < $1.0})) {
                    me.myCurrency.append(key)
                    me.myValues.append(value)
                }
                callback()
            case .failure:
                me.errorHandler("Erreur", "Taux de change indisponible pour le moment…")
            }
        }
    }
}
