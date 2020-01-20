//
//  GeolocationService.swift
//  Baluchon
//
//  Created by Fabrice Etiennette on 13/01/2020.
//  Copyright © 2020 Fabrice Etiennette. All rights reserved.
//

import CoreLocation
import UserNotifications

class GeolocationService: NSObject {

    let center = UNUserNotificationCenter.current()
    private let locationManager = CLLocationManager()

    var location: [CLLocation]?

    static var currentLocation: String = ""

    override init() {
        super.init()
        locationManager.requestAlwaysAuthorization()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.startUpdatingLocation()
        center.requestAuthorization(options: [.alert, .sound]) { granted, error in
            if error != nil, granted == true {
                print("permission given")
            }
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }

    func reverseGeocodeLocation(_ locations: CLLocation?, completionHandler: @escaping (_ placemark: [CLPlacemark]?, _ error: Error?) -> Void) {
        guard let location = locations else { return }
        CLGeocoder().reverseGeocodeLocation(location) { (placemark, error) in
            if error != nil {
                print("Some errors: \(String(describing: error?.localizedDescription))")
                completionHandler(nil, error)
            } else {
                guard let currentLocality = placemark?.first?.locality else { return }
                GeolocationService.currentLocation = currentLocality
                completionHandler(placemark, nil)
            }
        }
    }

    func updateWeatherForLocation(_ location: String, completionHandler: @escaping (_ placemark: [CLPlacemark]?, _ error: Error?) -> Void) {
        CLGeocoder().geocodeAddressString(location) { (placemark: [CLPlacemark]?, error: Error?) in
            if error != nil {
                print("Some errors: \(String(describing: error?.localizedDescription))")
                completionHandler(nil, error)
            } else {
                completionHandler(placemark, nil)
            }
        }
    }
}

extension GeolocationService: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = locations
        locationManager.stopUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    }
}
