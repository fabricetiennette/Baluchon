// swiftlint:disable force_cast
//
//  WeatherTableViewController.swift
//  Baluchon
//
//  Created by Fabrice Etiennette on 27/11/2019.
//  Copyright © 2019 Fabrice Etiennette. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class WeatherTableViewController: UITableViewController, NVActivityIndicatorViewable {

    private let viewModel = WeatherViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewModel()
        setupSearchBar()
        getWeatherFromLocation(location: viewModel.location)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0 {
            return viewModel.currentForcast.count
        } else {
            return viewModel.forcastData.count
        }
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 220
        } else {
            return 50
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dayData = viewModel.forcastData[indexPath.item]
        if indexPath.section == 0, let currentData = viewModel.currentForcast.first {
            let headerCell = tableView.dequeueReusableCell(withIdentifier: "HeaderCell", for: indexPath) as! HeaderCell
            headerCell.configureHeader(current: currentData, dayData: dayData, cityText: viewModel.location.capitalized)
            return headerCell
        } else if indexPath.section > 0 {
            let weatherCell = tableView.dequeueReusableCell(withIdentifier: "WeatherCell", for: indexPath) as! WeatherCell
            weatherCell.configureCell(dayData: dayData, indexPath: indexPath)
            return weatherCell
        } else {
            return UITableViewCell()
        }
    }
}

extension WeatherTableViewController: UISearchBarDelegate, UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        searchController.searchBar.placeholder = "Recherche..."
    }

    func setupSearchBar() {
        let searchController = UISearchController(searchResultsController: nil)
        let appearance = UINavigationBarAppearance()
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
        searchController.searchBar.placeholder = "Recherche..."
        searchController.searchBar.searchTextField.backgroundColor = .white
        navigationController?.navigationBar.isTranslucent = false
        definesPresentationContext = true
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let locationString = searchBar.text, !locationString.isEmpty {
            getWeatherFromLocation(location: locationString)
        }
    }
}

private extension WeatherTableViewController {

    enum Icon: String {
        case clearDay = "clear-day"
        case cloudy = "cloudy"
        case partlyCloudyDay = "partly-cloudy-day"
        case partlyCloudyNight = "partly-cloudy-night"
        case clearNight = "clear-night"
        case rain = "rain"
        case wind = "wind"
        case snow = "snow"
        case sleet = "sleet"
        case fog = "fog"
        case hail = "hail"
        case thunderstorm = "thunderstorm"
        case tornado = "tornado"
        var imageView: UIImageView {
            switch self {
            case .clearDay:
                return UIImageView(image: Asset.clearD.image)
            case .cloudy:
                return UIImageView(image: Asset.cloudyCloudy.image)
            case .partlyCloudyDay:
                return UIImageView(image: Asset.partlyCloudyD.image)
            case .clearNight:
                return UIImageView(image: Asset.clearN.image)
            case .rain:
                return UIImageView(image: Asset.rainRain.image)
            case .wind:
                return UIImageView(image: Asset.wind.image)
            case .partlyCloudyNight:
                return UIImageView(image: Asset.partlyCloudyN.image)
            case .snow:
                return UIImageView(image: Asset.snowing.image)
            case .sleet:
                return UIImageView(image: Asset.hailling.image)
            case .fog:
                return UIImageView(image: Asset.foggy.image)
            case .hail:
                return UIImageView(image: Asset.hailling.image)
            case .thunderstorm:
                return UIImageView(image: Asset.thunder.image)
            case .tornado:
                return UIImageView(image: Asset.tornadoo.image)
            }
        }
    }

    func backgroundView(currentIcon: String, icon: Icon?) -> UIImageView? {
        if currentIcon == icon?.rawValue {
            return icon?.imageView
        }
        return nil
    }

    func getWeatherFromLocation(location: String) {
        let size = CGSize(width: 50, height: 50)
        startAnimating(size, type: .ballSpinFadeLoader, color: .white, fadeInAnimation: nil)
        viewModel.updateWeather(location)
    }

    func configureViewModel() {
        viewModel.reloadHandler = { [weak self] in
            guard let me = self else { return }
            me.tableView.reloadData()
        }

        viewModel.errorHandler = { [weak self] titleText, messageText in
            guard let me = self else { return }
            me.showAlert(title: titleText, message: messageText)
            me.stopAnimating()
        }

        viewModel.backgroundViewHandler = { [weak self] currentIcon in
            guard let me = self else { return }
            let backgroundView = me.backgroundView(currentIcon: currentIcon, icon: Icon(rawValue: currentIcon))
            me.tableView.backgroundView = backgroundView
            me.stopAnimating()
        }
    }
}
