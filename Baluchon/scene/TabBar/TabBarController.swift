//
//  TabBarController.swift
//  Baluchon
//
//  Created by Fabrice Etiennette on 19/11/2019.
//  Copyright © 2019 Fabrice Etiennette. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

    override func awakeFromNib() {
        super.awakeFromNib()

        viewControllers?.forEach { viewController in
            guard let navigationVC = viewController as? UINavigationController else { return }
            let firstVC = navigationVC.viewControllers.first
            if let todayVC = firstVC as? TodayTableViewController {
                todayVC.viewModel = TodayViewModel()
            } else if let translateVC = firstVC as? TranslateViewController {                 translateVC.viewModel = TranslateViewModel()
            } else if let weatherTVC = firstVC as? WeatherViewController {
                weatherTVC.viewModel = WeatherViewModel()
            } else if let currencyVC = firstVC as? CurrencyViewController {
                currencyVC.viewModel = CurrencyViewModel()
            }
        }
    }
}
