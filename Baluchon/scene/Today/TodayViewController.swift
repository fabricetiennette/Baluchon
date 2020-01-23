//
//  TodayViewController.swift
//  Baluchon
//
//  Created by Fabrice Etiennette on 30/09/2019.
//  Copyright © 2019 Fabrice Etiennette. All rights reserved.
//

import UIKit
import CoreLocation

class TodayTableViewController: UITableViewController {

    private let viewModel = TodayViewModel()

    @IBOutlet private weak var dateUILabel: UILabel!

    @IBOutlet private weak var weatherView: UIView!
    @IBOutlet private weak var currentCityLabel: UILabel!
    @IBOutlet private weak var currentTempLabel: UILabel!
    @IBOutlet private weak var summaryLabel: UILabel!
    @IBOutlet private weak var dayLabel: UILabel!
    @IBOutlet private weak var minTempLabel: UILabel!
    @IBOutlet private weak var maxTempLabel: UILabel!

    @IBOutlet private weak var forexView: UIView!
    @IBOutlet private weak var dollarLabel: UILabel!
    @IBOutlet private weak var poundLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(checkNotificationStatus), name: UIApplication.didBecomeActiveNotification, object: nil)
        configureDateLabelsWithCurrentDate()
        showRate()
        configureViewModel()
    }

    @objc private func checkNotificationStatus() {
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            switch settings.authorizationStatus {
            case .authorized:
                self.showCurrentWeather()
            case .notDetermined:
                print("notDetermined")
            case .denied:
                print("denied")
            case .provisional:
                print("provisional")
            @unknown default:
                fatalError()
            }
        }
    }
}

private extension TodayTableViewController {
    func configureDateLabelsWithCurrentDate() {
        dayLabel.text = "\(viewModel.todayDayLabelText)  Today"
        dateUILabel.text = viewModel.dateUILabelText
    }

    func showRate() {
        viewModel.rateHandler = { [weak self] dollarLabelText, poundLabelText in
            guard let me = self else { return }
            me.dollarLabel.text = dollarLabelText
            me.poundLabel.text = poundLabelText
        }
        viewModel.getRate()
    }

    func showCurrentWeather() {
        viewModel.updateweather()
    }

    func configureViewModel() {
        viewModel.weatherHandler = { [weak self] weather in
            guard let me = self else { return }
            me.minTempLabel.text = weather.minTemperature
            me.maxTempLabel.text = weather.maxTemperature
            me.currentTempLabel.text = weather.temperature
            let summary = weather.iconSummary
            me.summaryLabel.text = summary?.replacingOccurrences(of: "-", with: " ")
        }
        viewModel.locationHandler = { [weak self] location in
            guard let me = self else { return }
            me.currentCityLabel.text = location
        }
    }
}
