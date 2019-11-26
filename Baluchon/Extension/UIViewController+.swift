//
//  UIViewController+.swift
//  Baluchon
//
//  Created by Fabrice Etiennette on 26/11/2019.
//  Copyright © 2019 Fabrice Etiennette. All rights reserved.
//

import UIKit

extension UIViewController {

    func alert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let isOk = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(isOk)
        present(alert, animated: true, completion: nil)
    }

    // Applies the text received to a UITextView
    func refreshScreen(text: String, textView: UITextView) {
        textView.text = text
    }
}
