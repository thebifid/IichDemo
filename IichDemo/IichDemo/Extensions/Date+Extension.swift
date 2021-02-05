//
//  Date+Extension.swift
//  IichDemo
//
//  Created by Vasiliy Matveev on 05.02.2021.
//

import Foundation

extension Date {
    func offsetFrom(date: Date) -> String {
        let dayHourMinuteSecond: Set<Calendar.Component> = [.day, .hour, .minute, .second]
        let difference = NSCalendar.current.dateComponents(dayHourMinuteSecond, from: date, to: self)

        let seconds = "\(difference.second ?? 0) second ago"
        let minutes = "\(difference.minute ?? 0) minutes ago"
        let hours = "\(difference.hour ?? 0) hours ago"
        let days = "\(difference.day ?? 0) days ago"

        if difference.day ?? 0 > 31 {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd.MM.yy HH:mm"
            return (formatter.string(from: date))
        }

        if let day = difference.day, day > 0 { return days }
        if let hour = difference.hour, hour > 0 { return hours }
        if let minute = difference.minute, minute > 0 { return minutes }
        if let second = difference.second, second > 0 { return seconds }
        return ""
    }
}
