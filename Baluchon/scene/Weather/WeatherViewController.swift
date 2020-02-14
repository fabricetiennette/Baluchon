//
//  WeatherTableViewController.swift
//  Baluchon
//
//  Created by Fabrice Etiennette on 27/11/2019.
//  Copyright © 2019 Fabrice Etiennette. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class WeatherViewController: UIViewController, NVActivityIndicatorViewable {

    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var minTemperatureLabel: UILabel!
    @IBOutlet weak var maxTemperatureLabel: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!

    var viewModel: WeatherViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchBar.delegate = self
        configureViewModel()
        getWeatherFromLocation(location: viewModel.location)
    }
}

extension WeatherViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let locationString = searchBar.text, !locationString.isEmpty {
            getWeatherFromLocation(location: locationString)
        }
       searchBar.resignFirstResponder()
    }
}

private extension WeatherViewController {

    func getWeatherFromLocation(location: String) {
        let size = CGSize(width: 50, height: 50)
        startAnimating(size, type: .ballSpinFadeLoader, color: .white, fadeInAnimation: nil)
        viewModel.weatherHandler = { [weak self] weather in
            guard let me = self else { return }
            let day = Date()
            me.dayLabel.text = day.formatted(dateFormat: "EEEE dd MMMM").capitalized
            me.temperatureLabel.text = weather.temperature
            me.maxTemperatureLabel.text = weather.maxTemperature
            me.minTemperatureLabel.text = weather.minTemperature
            me.summaryLabel.text = weather.iconSummary
            me.cityLabel.text = me.viewModel.location
            me.stopAnimating()
        }
        viewModel.updateWeather(location)
    }

    func configureViewModel() {
        viewModel.errorHandler = { [weak self] title, message in
            guard let me = self else { return }
            me.showAlert(title: title, message: message)
            me.stopAnimating()
        }
    }
}
