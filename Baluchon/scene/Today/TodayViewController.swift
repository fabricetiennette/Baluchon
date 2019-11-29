//
//  TodayViewController.swift
//  Baluchon
//
//  Created by Fabrice Etiennette on 30/09/2019.
//  Copyright © 2019 Fabrice Etiennette. All rights reserved.
//

import UIKit

class TodayTableViewController: UITableViewController {

//    private let forexRates = Exchange()

    @IBOutlet weak var dateUILabel: UILabel!
    @IBOutlet weak var weatherView: UIView!
    @IBOutlet weak var forexView: UIView!
    @IBOutlet weak var weatherImageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
//        forexRates.getExchangeRate()
        currentDate()
        configureView()
    }

    private func currentDate() {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE dd MMMM"
        let date = formatter.string(from: Date())
        dateUILabel.text = date
    }
}

private extension TodayTableViewController {
    func configureView() {
        weatherImageView.layer.cornerRadius = 10
        weatherView.layer.cornerRadius = 10
        forexView.layer.cornerRadius = 10
    }
}
