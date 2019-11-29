//
//  TranslateViewController.swift
//  Baluchon
//
//  Created by Fabrice Etiennette on 30/09/2019.
//  Copyright © 2019 Fabrice Etiennette. All rights reserved.
//

import UIKit

class TranslateViewController: UIViewController {

    @IBOutlet weak private var toTranslateTextView: UITextView!
    @IBOutlet weak private var translateResultLabel: UILabel!
    @IBOutlet weak private var translateButton: UIButton!
    @IBOutlet weak private var exchangeLanguage: UIButton!
    @IBOutlet weak private var frLanguage: UILabel!
    @IBOutlet weak private var enLanguage: UILabel!

    private let translate = Translate()
    var index: Int = 0

    // Called when the user click on the view (outside the UITextField).
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTextView()
    }

    @IBAction private func changeLanguage(_ sender: UIButton) {
        toTranslateTextView.resignFirstResponder()
        sender.rotateIt()
        (frLanguage.text, enLanguage.text) = (enLanguage.text, frLanguage.text)
        if frLanguage.text == "Fr" {
            self.index = 0
        } else {
            self.index = 1
        }
    }

    @IBAction func didTapTranslateButton(_ sender: Any) {
        toTranslateTextView.resignFirstResponder()
        guard let text = toTranslateTextView.text, text != "" else {
            alert(title: "Error", message: "Text Missing")
            return
        }

        translate.translate(index: index, text: text) { [weak self] (success, translatedText) in
            if success {
                self?.translateResultLabel.text = translatedText
            } else {
                self?.alert(title: "Error", message: "Web service problem")
            }
        }
    }
}

private extension TranslateViewController {
    func configureTextView() {
        toTranslateTextView.layer.borderColor = UIColor.lightGray.cgColor
        toTranslateTextView.layer.borderWidth = 2
        toTranslateTextView.layer.cornerRadius = 5
        translateButton.layer.cornerRadius = 5
    }
}
