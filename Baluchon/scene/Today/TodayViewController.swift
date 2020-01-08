//
//  TodayViewController.swift
//  Baluchon
//
//  Created by Fabrice Etiennette on 30/09/2019.
//  Copyright © 2019 Fabrice Etiennette. All rights reserved.
//

import UIKit
import CoreLocation

class TodayTableViewController: UITableViewController, CLLocationManagerDelegate {

    private let viewModel = TodayViewModel()
    private let manager = CLLocationManager()

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
        configureDateLabelsWithCurrentDate()
        showRate()
        manager.delegate = self
        manager.requestAlwaysAuthorization()
        manager.requestLocation()
        manager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {}

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        CLGeocoder().reverseGeocodeLocation(location) { (placemark, error) in
            if error != nil {
                print("Some errors: \(String(describing: error?.localizedDescription))")
            } else {
                if let location = placemark?.first?.locality {
                    TodayViewModel.currentPlace = location
                    self.updateWeatherForLocation(location: location)
                }
            }
        }
    }

    private func updateWeatherForLocation(location: String) {
        CLGeocoder().geocodeAddressString(location) { (placemarks: [CLPlacemark]?, error: Error?) in
            if error == nil {
                if let location = placemarks?.first?.location {
                    self.viewModel.weatherHandler = { [weak self] minTemperature, maxTemperature, temperature, iconSummary  in
                        guard let me = self else { return }
                        me.minTempLabel.text = minTemperature
                        me.maxTempLabel.text = maxTemperature
                        me.currentTempLabel.text = temperature
                        me.summaryLabel.text = iconSummary
                        me.currentCityLabel.text = TodayViewModel.currentPlace
                    }
                    self.viewModel.getCurrentWeather(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
                }
            }
        }
    }
}

private extension TodayTableViewController {
    func configureDateLabelsWithCurrentDate() {
        dayLabel.text = "\(viewModel.todayDayLabelText)  Today"
        dateUILabel.text = viewModel.todayDayLabelText
    }

    func showRate() {
        viewModel.rateHandler = { [weak self] dollarLabelText, poundLabelText in
            guard let me = self else { return }
            me.dollarLabel.text = dollarLabelText
            me.poundLabel.text = poundLabelText
        }
        viewModel.getRate()
    }
}
