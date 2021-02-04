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

    enum Tag: String {
        case quote, spoiler, strikethrough
    }

    func fromSpanToTag(className: [Tag]) -> String {
        var result: String = self
        var spanClass: String = ""
        var tag: String = ""

        className.forEach { currentTag in
            switch currentTag {
            case .quote:
                spanClass = "unkfunc"
                tag = "quote"
            case .spoiler:
                spanClass = "spoiler"
                tag = "spoiler"
            case .strikethrough:
                spanClass = "s"
                tag = "strikethrough"
            }

            let detectedCount = result.detect(regex: "<span class=\"\(spanClass)\">[^>]+</span>")
            detectedCount.forEach { _ in
                let range = result.range(of: "<span class=\"\(spanClass)\">[^>]+</span>",
                                         options: .regularExpression, range: nil, locale: nil)
                if let range = range {
                    let startIndex = range.lowerBound
                    let endIndex = range.upperBound
                    let text = String(result[result.index(startIndex, offsetBy: 15 + spanClass.count) ... result.index(endIndex, offsetBy: -8)])
                    result = result.replacingOccurrences(of: "<span class=\"\(spanClass)\">[^>]+</span>",
                                                         with: "<\(tag)>\(text)</\(tag)>",
                                                         options: .regularExpression, range: range)
                }
            }
        }
        return result
    }

    func spacingBetweenBlockTags() -> String {
        var string = self
        string = string.replacingOccurrences(of: "<p>", with: "<br><p>", options: .literal, range: nil)
        string = string.replacingOccurrences(of: "<h3>", with: "<br><h3>", options: .literal, range: nil)
        string = string.replacingOccurrences(of: "</h3>", with: "</h3><br><br>", options: .literal, range: nil)
        return string
    }
}
