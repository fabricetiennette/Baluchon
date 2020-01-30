//
//  TranslateViewController.swift
//  Baluchon
//
//  Created by Fabrice Etiennette on 30/09/2019.
//  Copyright © 2019 Fabrice Etiennette. All rights reserved.
//

import UIKit

class TranslateViewController: UIViewController {

    @IBOutlet weak var barView: UIView!
    @IBOutlet private weak var toTranslateTextView: UITextView!
    @IBOutlet private weak var translateResultLabel: UILabel!
    @IBOutlet private weak var translateButton: UIButton!
    @IBOutlet private weak var exchangeLanguage: UIButton!
    @IBOutlet private weak var frLanguage: UILabel!
    @IBOutlet private weak var enLanguage: UILabel!

    private let viewModel = TranslateViewModel()
    private var sourceLanguage: Language = .fr

    // Called when the user click on the view (outside the UITextField).
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTextView()
        configureViewModel()
    }

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
            showAlert(title: L10n.Localizable.error, message: L10n.Localizable.missingtext)
            return
        }

        let translationBody = Translate(source: sourceLanguage, text: text)
        viewModel.doTranslation(translationBody: translationBody)
    }
}

private extension TranslateViewController {
    func configureTextView() {
        toTranslateTextView.layer.borderColor = UIColor.lightGray.cgColor
        toTranslateTextView.layer.borderWidth = 2
        toTranslateTextView.layer.cornerRadius = 5
        translateButton.layer.cornerRadius = 10
        barView.roundCorners([.bottomLeft, .bottomRight], radius: 15)
    }

    func configureViewModel() {
        viewModel.errorHandler = { [weak self] titleText, messageText in
            guard let me = self else { return }
            me.showAlert(title: titleText, message: messageText)
        }
        viewModel.translatedTextHandler = { [weak self] translatedText in
            guard let me = self else { return }
            me.translateResultLabel.text = translatedText
        }
    }
}
