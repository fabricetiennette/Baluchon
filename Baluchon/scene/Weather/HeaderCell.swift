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

    @IBOutlet private weak var currentTemperatureLabel: UILabel!
    @IBOutlet private weak var cityLabel: UILabel!
    @IBOutlet private weak var summaryLabel: UILabel!
    @IBOutlet private weak var daylabel: UILabel!
    @IBOutlet private weak var temperatureMaxLabel: UILabel!
    @IBOutlet private weak var temperatureMinLabel: UILabel!

    private var current: Currently!
    private var dayData: DayData!

    func configureHeader(current: Currently, dayData: DayData, cityText: String) {
        self.current = current
        self.dayData = dayData
        today.dateFormat = "EEEE"
        daylabel.text = "\(today.string(from: Date()).capitalized)  \(L10n.Localizable.today)"
        currentTemperatureLabel.text = "\(Int(current.temperature))°"
        cityLabel.text = cityText
        temperatureMaxLabel.text = "\(Int(dayData.temperatureMax))"
        temperatureMinLabel.text = "\(Int(dayData.temperatureMin))"
        let summary = current.icon.capitalized
        summaryLabel.text = summary.replacingOccurrences(of: "-", with: " ")
    }
}
