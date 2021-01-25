//
//  AlertAssist.swift
//  IichDemo
//
//  Created by Vasiliy Matveev on 23.01.2021.
//

import UIKit

class AlertAssist {
    static func alertWithOk(title: String, message: String) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(okAction)
        return alert
    }

    static func alertWithInput(title: String, message: String, handler: @escaping (String) -> Void) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addTextField()
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            handler(alert.textFields?.first?.text ?? "")
        }))

        return alert
    }
}
