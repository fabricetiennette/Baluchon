//
//  ForeignExchangeViewController.swift
//  Baluchon
//
//  Created by Fabrice Etiennette on 30/09/2019.
//  Copyright © 2019 Fabrice Etiennette. All rights reserved.
//

import UIKit

class ForeignExchangeViewController: UIViewController {

    private let exchange = Exchange()

    var activeCurrency: Double = 0

    @IBOutlet weak private var currencyInputTextField: UITextField!
    @IBOutlet weak private var resultLabel: UILabel!
    @IBOutlet weak private var currencyPickerView: UIPickerView!
    @IBOutlet weak private var convertButton: UIButton!

    // Called when the user click on the view (outside the UITextField).
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    override func viewDidAppear(_ animated: Bool) {
        exchange.getExchangeRate { (success) in
            if success {
            self.currencyPickerView.reloadAllComponents()
            } else {
                print("error")
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        currencyPickerView.delegate = self
        currencyPickerView.dataSource = self
    }

    @IBAction func action(_ sender: AnyObject) {
        currencyInputTextField.resignFirstResponder()
        if currencyInputTextField.text != "" {
            guard let text = currencyInputTextField.text else { return }
            guard let amount = Double(text) else { return }
            let result = amount * activeCurrency
            resultLabel.text = String(format: "%.2f", result)
        } else {
            resultLabel.text = ""
        }
    }
}

extension ForeignExchangeViewController: UIPickerViewDelegate, UIPickerViewDataSource {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return exchange.myCurrency.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return exchange.myCurrency[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        activeCurrency = exchange.myValues[row]
    }
}
