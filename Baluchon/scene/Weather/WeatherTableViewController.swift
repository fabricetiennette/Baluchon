// swiftlint:disable force_cast
//
//  WeatherTableViewController.swift
//  Baluchon
//
//  Created by Fabrice Etiennette on 27/11/2019.
//  Copyright © 2019 Fabrice Etiennette. All rights reserved.
//

import UIKit
import CoreLocation
import Moya

class WeatherTableViewController: UITableViewController, CLLocationManagerDelegate {

    @IBOutlet weak var searchBar: UISearchBar!

    let viewModel = WeatherViewModel()
    private let manager = CLLocationManager()

    private var forcastData: [DayData] = []
    private var currentForcast: [Currently] = []
    private var currentPlace: String!
    private let weatherRest = WeatherClient()

    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        manager.delegate = self
        updateWeatherForLocation(location: TodayViewModel.currentPlace)
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        if let locationString = searchBar.text, !locationString.isEmpty {
            viewModel.currentPlace = locationString
            updateWeatherForLocation(location: locationString)
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // handle the error
    }

    private func updateWeatherForLocation(location: String) {
        CLGeocoder().geocodeAddressString(location) { (placemarks: [CLPlacemark]?, error: Error?) in
            if error == nil {
                if let location = placemarks?.first?.location {
                    self.viewModel.getCurrentWeather(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude, tableView: self.tableView)
                    self.viewModel.backgroundViewHandler = { [weak self] currentIcon in
                        guard let me = self else { return }
                        let backgroundView = me.backgroundView(currentIcon: currentIcon, icon: Icon(rawValue: currentIcon))
                        me.tableView.backgroundView = backgroundView
                    }
                }
            }
        }
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
            if viewModel.currentPlace.isEmpty {
                currentPlace = TodayViewModel.currentPlace
            } else {
                currentPlace = viewModel.currentPlace
            }
            headerCell.configureHeader(current: currentData, dayData: dayData, cityText: currentPlace.capitalized)
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

extension WeatherTableViewController: UISearchBarDelegate {}

private extension WeatherTableViewController {

    enum Icon: String {
        case clearDay = "clear-day"
        case cloudy = "cloudy"
        case partlyCloudyDay = "partly-cloudy-day"
        case partlyCloudyNight = "partly-cloudy-night"
        case clearNight = "clear-night"
        case rain = "rain"
        case wind = "wind"
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
            }
        }
    }

    func backgroundView(currentIcon: String, icon: Icon?) -> UIImageView? {
        if currentIcon == icon?.rawValue {
            return icon?.imageView
        }
        return nil
    }
}
