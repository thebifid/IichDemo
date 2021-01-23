//
//  AlertAssist.swift
//  IichDemo
//
//  Created by Vasiliy Matveev on 23.01.2021.
//

import UIKit

class AlertAssist {
    static func alertWithInput(title: String, message: String, handler: @escaping (UIAlertAction) -> Void) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

        alert.addTextField { textField in
            textField.text = ""
        }

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: handler))

        return alert
    }
}
