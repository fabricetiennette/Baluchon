//
//  TodayViewController.swift
//  Baluchon
//
//  Created by Fabrice Etiennette on 30/09/2019.
//  Copyright © 2019 Fabrice Etiennette. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class TodayTableViewController: UITableViewController, NVActivityIndicatorViewable {

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

    private let viewModel = TodayViewModel(geolocationService: GeolocationService(), currencyClient: CurrencyClient())

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(checkNotificationStatus), name: UIApplication.didBecomeActiveNotification, object: nil)
        errorConfiguration()
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
        dayLabel.text = viewModel.todayDayLabelText
        dateUILabel.text = viewModel.dateUILabelText
    }

    func showRate() {
        viewModel.rateHandler = { [weak self] poundLabelText, dollarLabelText in
            guard let me = self else { return }
            me.poundLabel.text = poundLabelText
            me.dollarLabel.text = dollarLabelText
        }
        viewModel.getRate()
    }

    func showCurrentWeather() {
        viewModel.updateweather()
    }

    func errorConfiguration() {
        viewModel.errorHandler = { [weak self] title, message in
            guard let me = self else { return }
            me.showAlert(title: title, message: message)
            me.stopAnimating()
        }
    }

    func configureViewModel() {
        let size = CGSize(width: 50, height: 50)
        startAnimating(size, type: .ballSpinFadeLoader, color: .white, fadeInAnimation: nil)
        viewModel.weatherHandler = { [weak self] weather in
            guard let me = self else { return }
            me.minTempLabel.text = weather.minTemperature
            me.maxTempLabel.text = weather.maxTemperature
            me.currentTempLabel.text = weather.temperature
            let summary = weather.iconSummary
            me.summaryLabel.text = summary?.replacingOccurrences(of: "-", with: " ")
            me.stopAnimating()
        }
        viewModel.locationHandler = { [weak self] location in
            guard let me = self else { return }
            me.currentCityLabel.text = location
        }
    }
}
