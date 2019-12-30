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
        manager.requestAlwaysAuthorization()
        manager.requestLocation()
        manager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        viewModel.backgroundViewHandler = { [weak self] currentIcon in
            guard let me = self else { return }
            let backgroundView = me.backgroundView(currentIcon: currentIcon)
            me.tableView.backgroundView = backgroundView
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        CLGeocoder().reverseGeocodeLocation(location) { (placemark, error) in
            if error != nil {
                print("Some errors: \(String(describing: error?.localizedDescription))")
            } else {
                if let location = placemark?.first?.locality {
                    self.currentPlace = location
                    self.updateWeatherForLocation(location: location)
                }
            }
        }
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        if let locationString = searchBar.text, !locationString.isEmpty {
            self.currentPlace = locationString
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
                    self.weatherRest.getCurrentWeather(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude) { (forcastData, currentForcast, error) in
                        self.forcastData = forcastData
                        self.currentForcast = currentForcast
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                        if let error = error {
                            print(error)
                        }
                    }
                }
            }
        }
    }

    private enum Icon: String {
        case clearDay = "clear-day"
        case cloudy = "cloudy"
        case partlyCloudyDay = "partly-cloudy-day"
        var imageView: UIImageView {
            switch self {
            case .clearDay:
                return UIImageView(image: Asset.clearD.image)
            case .cloudy:
                return UIImageView(image: Asset.cloudyCloudy.image)
            case .partlyCloudyDay:
                return UIImageView(image: Asset.partlyCloudyD.image)
            }
        }
    }

    private func backgroundView(currentIcon: String) -> UIImageView? {
        if currentIcon == Icon.clearDay.rawValue {
            return Icon.clearDay.imageView
        } else if currentIcon == Icon.cloudy.rawValue {
            return Icon.cloudy.imageView
        } else if currentIcon == Icon.partlyCloudyDay.rawValue {
            return Icon.partlyCloudyDay.imageView
        }
        return nil
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0 {
            return currentForcast.count
        } else {
            return forcastData.count
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
        let dayData = forcastData[indexPath.item]
        if indexPath.section == 0, let currentData = currentForcast.first {
            let headerCell = tableView.dequeueReusableCell(withIdentifier: "HeaderCell", for: indexPath) as! HeaderCell
            headerCell.configureHeader(current: currentData, dayData: dayData, cityText: currentPlace)
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
