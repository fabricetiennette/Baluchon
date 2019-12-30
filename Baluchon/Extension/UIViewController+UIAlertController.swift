//
//  UIViewController+.swift
//  Baluchon
//
//  Created by Fabrice Etiennette on 26/11/2019.
//  Copyright © 2019 Fabrice Etiennette. All rights reserved.
//

import UIKit

extension UIViewController {
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}
