//
//  HeaderCell.swift
//  Baluchon
//
//  Created by Fabrice Etiennette on 19/12/2019.
//  Copyright © 2019 Fabrice Etiennette. All rights reserved.
//

import UIKit

private let today = DateFormatter()

class HeaderCell: UITableViewCell {

    private var current: Currently!
    private var dayData: DayData!

    @IBOutlet private weak var currentTemperatureLabel: UILabel!
    @IBOutlet private weak var cityLabel: UILabel!
    @IBOutlet private weak var summaryLabel: UILabel!
    @IBOutlet private weak var daylabel: UILabel!
    @IBOutlet private weak var temperatureMaxLabel: UILabel!
    @IBOutlet private weak var temperatureMinLabel: UILabel!

    func configureHeader(current: Currently, dayData: DayData, cityText: String) {
        self.current = current
        self.dayData = dayData
        today.dateFormat = "EEEE"
        daylabel.text = ("\(today.string(from: Date()))  Today")
        currentTemperatureLabel.text = String("\(Int(current.temperature))°")
        cityLabel.text = cityText
        temperatureMaxLabel.text = String(Int(dayData.temperatureMax))
        temperatureMinLabel.text = String(Int(dayData.temperatureMin))
        summaryLabel.text = current.summary
    }
}
