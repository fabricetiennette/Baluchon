//
//  ForeignExchangeViewController.swift
//  Baluchon
//
//  Created by Fabrice Etiennette on 30/09/2019.
//  Copyright © 2019 Fabrice Etiennette. All rights reserved.
//

import UIKit

class CurrencyExchangeViewController: UIViewController {

    private let exchange = CurrencyClient()

    var myCurrency: [String] = []
    var myValues: [Double] = []
    var activeCurrency: Double = 0

    @IBOutlet weak var selectLabel: UILabel!
    @IBOutlet weak var currencyPickerView: UIPickerView!
    @IBOutlet weak private var currencyInputTextField: UITextField!
    @IBOutlet weak private var resultLabel: UILabel!
    @IBOutlet weak private var convertButton: UIButton!

    // Called when the user click on the view (outside the UITextField).
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        selectLabel.roundCorners([.bottomLeft, .bottomRight], radius: 15)
        convertButton.layer.cornerRadius = 10
        currencyPickerView.delegate = self
        currencyPickerView.dataSource = self
        exchange.getExchangeRate { (myCurrency, myValues, error) in
            self.myCurrency = myCurrency
            self.myValues = myValues
            self.currencyPickerView.reloadAllComponents()
            if let error = error {
                print(error)
            }
        }
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

extension CurrencyExchangeViewController: UIPickerViewDelegate, UIPickerViewDataSource {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return myCurrency.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return myCurrency[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        activeCurrency = myValues[row]
        let choice = myCurrency[row]
        convertButton.setTitle("Convert to \(choice)", for: .normal)
    }
}
