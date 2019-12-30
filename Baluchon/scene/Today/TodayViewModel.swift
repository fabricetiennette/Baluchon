//
//  TodayViewModel.swift
//  Baluchon
//
//  Created by Fabrice Etiennette on 27/12/2019.
//  Copyright © 2019 Fabrice Etiennette. All rights reserved.
//

import Foundation

struct TodayViewModel {
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
}
