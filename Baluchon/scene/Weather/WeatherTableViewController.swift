//
//  WeatherTableViewController.swift
//  Baluchon
//
//  Created by Fabrice Etiennette on 27/11/2019.
//  Copyright © 2019 Fabrice Etiennette. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherTableViewController: UITableViewController {

    @IBOutlet weak var searchBar: UISearchBar!

    var forcastData = [Weather]()

    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        updateWeatherForLocation(location: "Curepipe, Mauritius")
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        if let locationString = searchBar.text, !locationString.isEmpty {
            updateWeatherForLocation(location: locationString)
        }
    }

    func updateWeatherForLocation(location: String) {
        CLGeocoder().geocodeAddressString(location) { (placemarks: [CLPlacemark]?, error: Error?) in
            if error == nil {
                if let location = placemarks?.first?.location {
                    Weather.forecast(withLocation: location.coordinate, completion: { (results: [Weather]?) in

                        if let weatherData = results {
                            self.forcastData = weatherData

                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                            }
                        }
                    })
                }
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return forcastData.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let date = Calendar.current.date(byAdding: .day, value: section, to: Date())
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd, yyyy"

        return dateFormatter.string(from: date!)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        let weatherObject = forcastData[indexPath.section]

        cell.textLabel?.text = weatherObject.summary
        cell.detailTextLabel?.text = "\(Int(weatherObject.temperature)) °C"
        cell.imageView?.image = UIImage(named: weatherObject.icon)
        return cell
    }
}

extension WeatherTableViewController: UISearchBarDelegate {}
