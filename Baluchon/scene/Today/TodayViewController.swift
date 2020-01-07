//
//  TodayViewController.swift
//  Baluchon
//
//  Created by Fabrice Etiennette on 30/09/2019.
//  Copyright © 2019 Fabrice Etiennette. All rights reserved.
//

import UIKit

class TodayTableViewController: UITableViewController {

    private let viewModel = TodayViewModel()

    @IBOutlet weak var dateUILabel: UILabel!
    @IBOutlet weak var weatherView: UIView!

    @IBOutlet weak var forexView: UIView!
    @IBOutlet weak var localisationLabel: UILabel!
    @IBOutlet weak var localisationTempLabel: UILabel!
    @IBOutlet weak var localisationSummaryLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var minTempTodayLabel: UILabel!

    @IBOutlet weak var dollarLabel: UILabel!
    @IBOutlet weak var poundLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureDateLabelsWithCurrentDate()
        showRate()
    }
}

private extension TodayTableViewController {
    func configureDateLabelsWithCurrentDate() {
        dayLabel.text = viewModel.todayDayLabelText
        dateUILabel.text = viewModel.todayDayLabelText
    }

    func showRate() {
        viewModel.getRate()
        dollarLabel.text = viewModel.dollar
        poundLabel.text = viewModel.pound
    }
}
