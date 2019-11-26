//
//  TranslateViewController.swift
//  Baluchon
//
//  Created by Fabrice Etiennette on 30/09/2019.
//  Copyright © 2019 Fabrice Etiennette. All rights reserved.
//

import UIKit

class TranslateViewController: UIViewController {

    @IBOutlet weak var toTranslateTextField: UITextView!
    @IBOutlet weak var translationResultTextView: UITextView!
    @IBOutlet weak var translateButton: UIButton!
    @IBOutlet weak var exchangeLanguage: UIButton!
    @IBOutlet weak var frLanguage: UILabel!
    @IBOutlet weak var enLanguage: UILabel!

    var translate = Translate()
    var index: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction private func changeLanguage(_ sender: UIButton) {
        sender.rotateIt()
        (frLanguage.text, enLanguage.text) = (enLanguage.text, frLanguage.text)
        if frLanguage.text == "Fr" {
            self.index = 0
        } else {
            self.index = 1
        }
    }

    @IBAction func didTapeTranslateButton(_ sender: Any) {
        guard toTranslateTextField.text != "" else {
            alert(title: "Error", message: "Text Missing")
            return
        }

        translate.translate(index: index, text: toTranslateTextField.text) { (success, translatedText) in
            if success == true {
                self.refreshScreen(text: translatedText!, textView: self.translationResultTextView)
            } else {
                self.alert(title: "Error", message: "Web service problem")
            }
        }
    }
}
