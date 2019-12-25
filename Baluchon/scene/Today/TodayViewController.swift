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
    private let weatherToday: [Currently] = []

    @IBOutlet weak var dateUILabel: UILabel!
    @IBOutlet weak var weatherView: UIView!
    @IBOutlet weak var forexView: UIView!
    @IBOutlet weak var localisationLabel: UILabel!
    @IBOutlet weak var localisationTempLabel: UILabel!
    @IBOutlet weak var localisationSummaryLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var minTempTodayLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        currentDate()
        configureView()
    }

    private func currentDate() {
        let formatter = DateFormatter()
        let today = DateFormatter()
        today.dateFormat = "EEEE"
        formatter.dateFormat = "EEEE dd MMMM"
        dayLabel.text = ("\(today.string(from: Date()))  Today")
        dateUILabel.text = formatter.string(from: Date())
    }
}

private extension TodayTableViewController {
    func configureView() {
        weatherView.layer.cornerRadius = 15
        weatherView.layer.shadowColor =  UIColor.black.cgColor
        weatherView.layer.shadowOffset = .zero
        weatherView.layer.shadowOpacity = 0.8
        weatherView.layer.shadowRadius = 5
        forexView.layer.cornerRadius = 15
        forexView.layer.shadowColor = UIColor.black.cgColor
        forexView.layer.shadowOffset = CGSize.zero
        forexView.layer.shadowOpacity = 0.8
        forexView.layer.shadowRadius = 5
    }
}
