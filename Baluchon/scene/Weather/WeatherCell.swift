//
//  WeatherCell.swift
//  Baluchon
//
//  Created by Fabrice Etiennette on 19/12/2019.
//  Copyright © 2019 Fabrice Etiennette. All rights reserved.
//

import UIKit

class WeatherCell: UITableViewCell {

    private var dayData: DayData!

    @IBOutlet private weak var dayLabel: UILabel!
    @IBOutlet private weak var weatherImageView: UIImageView!
    @IBOutlet private weak var temperatureMaxLabel: UILabel!
    @IBOutlet private weak var temperatureMinLabel: UILabel!

    func configureCell(dayData: DayData, indexPath: IndexPath) {
        self.dayData = dayData

        self.backgroundColor = UIColor.clear
        if let date = Calendar.current.date(byAdding: .day, value: indexPath.item, to: Date()) {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "EEEE"
            dayLabel.text = dateFormatter.string(from: date)
        }
        weatherImageView.image = UIImage(named: dayData.icon)
        temperatureMaxLabel.text = String(Int(dayData.temperatureMax))
        temperatureMinLabel.text = String(Int(dayData.temperatureMin))
    }
}
