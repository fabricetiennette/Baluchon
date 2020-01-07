//
//  TodayViewModel.swift
//  Baluchon
//
//  Created by Fabrice Etiennette on 27/12/2019.
//  Copyright © 2019 Fabrice Etiennette. All rights reserved.
//

import Foundation
import UIKit

class TodayViewModel {
    private let currencyClient = CurrencyClient()

    var myCurrency: [String] = []
    var myValues: [Double] = []
    private let todayDate = Date()
    private let shortDateFormat = "EEEE"
    private let longDateFormat = "EEEE dd MMMM"
}

extension TodayViewModel {
    var todayDayLabelText: String {
        return todayDate.formatted(dateFormat: shortDateFormat)
    }

    var dateUILabelText: String {
        return todayDate.formatted(dateFormat: longDateFormat)
    }

    func getRate() {
        currencyClient.getExchangeRate { [weak self] (myCurrency, myValues, error) in
            guard let me = self else { return }
            me.myCurrency = myCurrency
            me.myValues = myValues
            print(me.myValues)
            if let error = error {
                print(error)
            }
        }
    }

    var dollar: String {
//        print("dollar :\(myValues.first as Any)")
        guard let dollar = myValues.first else { return "" }
        let rate = String(format: "%.2f", dollar)
        return rate
    }

    var pound: String {
//        print("pound :\(myValues[1] as Any)")
        guard let pound = myValues.last else { return "" }
        let rate = String(format: "%.2f", pound)
        return rate
    }
}
