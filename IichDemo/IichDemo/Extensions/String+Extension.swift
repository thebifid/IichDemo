//
//  String+Extension.swift
//  IichDemo
//
//  Created by Vasiliy Matveev on 01.02.2021.
//

import UIKit

extension String {
    func height(constraintedWidth width: CGFloat, font: UIFont = .systemFont(ofSize: 14)) -> CGFloat {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: .greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.text = self
        label.font = font
        label.sizeToFit()
        return label.frame.height
    }

    func clearHTMLTags() -> String {
        return replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
    }
}
