//
//  CurrencyViewController.swift
//  Baluchon
//
//  Created by Fabrice Etiennette on 30/09/2019.
//  Copyright © 2019 Fabrice Etiennette. All rights reserved.
//

import UIKit

class CurrencyViewController: UIViewController {

    private let viewModel = CurrencyViewModel()
    private var activeCurrency: Double = 0

    @IBOutlet private weak var selectLabel: UILabel!
    @IBOutlet private weak var currencyPickerView: UIPickerView!
    @IBOutlet private weak var currencyInputTextField: UITextField!
    @IBOutlet private weak var resultLabel: UILabel!
    @IBOutlet private weak var convertButton: UIButton!

    // Called when the user click on the view (outside the UITextField).
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureCurrency()
        configureRate()
        currencyPickerView.delegate = self
        currencyPickerView.dataSource = self
        viewModel.errorHandler = { [weak self] titleText, messageText in
            guard let me = self else { return }
            me.showAlert(title: titleText, message: messageText)
        }
    }

    @IBAction func action(_ sender: AnyObject) {
        currencyInputTextField.resignFirstResponder()
        if currencyInputTextField.text != "" {
            guard let text = currencyInputTextField.text else { return }
            let calculation = text.doubleValue * activeCurrency
            let result = String(format: "%.2f", calculation)
            resultLabel.text = result.replacingOccurrences(of: ".", with: ",")
        } else {
            resultLabel.text = ""
        }
    }
}

extension CurrencyViewController: UIPickerViewDelegate, UIPickerViewDataSource {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return viewModel.myCurrency.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return viewModel.myCurrency[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        activeCurrency = viewModel.myValues[row]
        let choice = viewModel.myCurrency[row]
        convertButton.setTitle("\(L10n.Localizable.convert) \(choice)", for: .normal)
    }
}

private extension CurrencyViewController {
    func configureCurrency() {
        selectLabel.roundCorners([.bottomLeft, .bottomRight], radius: 15)
        convertButton.layer.cornerRadius = 10
    }

    func configureRate() {
        viewModel.getRate { [weak self] in
            guard let me = self else { return }
            me.currencyPickerView.reloadAllComponents()
        }
    }
}
