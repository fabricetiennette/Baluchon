//
//  TranslateViewController.swift
//  Baluchon
//
//  Created by Fabrice Etiennette on 30/09/2019.
//  Copyright © 2019 Fabrice Etiennette. All rights reserved.
//

import UIKit

class TranslateViewController: UIViewController {

    @IBOutlet private weak var barView: UIView!
    @IBOutlet private weak var toTranslateTextView: UITextView!
    @IBOutlet private weak var translateResultLabel: UILabel!
    @IBOutlet private weak var translateButton: UIButton!
    @IBOutlet private weak var exchangeLanguage: UIButton!
    @IBOutlet private weak var frLanguage: UILabel!
    @IBOutlet private weak var enLanguage: UILabel!

    var viewModel: TranslateViewModel!
    private var sourceLanguage: Language = .fr

    // Called when the user click on the view (outside the UITextField).
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewModel()
        configureStyle()
    }
}

private extension TranslateViewController {

    func configureStyle() {
        translateButton.layer.cornerRadius = 10
    }
    func configureViewModel() {
        viewModel.errorHandler = { [weak self] title, message in
            guard let me = self else { return }
            me.showAlert(title: title, message: message)
        }
        viewModel.translatedTextHandler = { [weak self] translatedText in
            guard let me = self else { return }
            me.translateResultLabel.text = translatedText
        }
    }
}

private extension TranslateViewController {
    @IBAction private func changeLanguage(_ sender: UIButton) {
           toTranslateTextView.resignFirstResponder()
           sender.rotateIt()
           (frLanguage.text, enLanguage.text) = (enLanguage.text, frLanguage.text)
           sourceLanguage = (sourceLanguage == .fr) ? .en : .fr
       }

       @IBAction func didTapTranslateButton(_ sender: Any) {
           toTranslateTextView.resignFirstResponder()
           let text = toTranslateTextView.text.trimmingCharacters(in: .whitespaces)
           guard !text.isEmpty else {
               showAlert(title: "Erreur", message: "Le texte à traduire est manquant.")
               return
           }

           let translationBody = Translate(source: sourceLanguage, text: text)
           viewModel.doTranslation(translationBody: translationBody)
       }
}
