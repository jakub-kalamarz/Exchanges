//
//  Date+LastWeek.swift
//  Exchanges
//
//  Created by Jakub Kalamarz on 31/01/2021.
//

import Foundation

extension Calendar {
    func getLastWeekDay(_ format: String = "yyyy-MM-dd", dayOfWeek _: Int = 2) -> String {
        let now = Date()
        let formater = DateFormatter()
        formater.dateFormat = format

        var components = Calendar.current.dateComponents([.weekOfYear, .year], from: now)
        if let week = components.weekOfYear {
            components.weekOfYear = week - 2
        }

        let componentsDate = Calendar.current.nextDate(after: now, matching: components, matchingPolicy: .strict, repeatedTimePolicy: .first, direction: .backward)

        return formater.string(from: componentsDate ?? Date())
    }

    func getToday(_ format: String = "yyyy-MM-dd") -> String {
        let now = Date()
        let formater = DateFormatter()
        formater.dateFormat = format

        return formater.string(from: now)
    }

    func getDateFromString(string: String, format: String = "yyyy-MM-dd") -> Date? {
        let formater = DateFormatter()
        formater.dateFormat = format

        return formater.date(from: string)
    }

    func getStringFromDate(date: Date) -> String {
        let formater = DateFormatter()
        formater.dateStyle = .long
        formater.timeStyle = .none
        formater.locale = Locale(identifier: "en_GB")

        return formater.string(from: date)
    }

    func getShortStringFromDate(date: Date) -> String {
        let formater = DateFormatter()
        formater.dateFormat = "d.MM"

        return formater.string(from: date)
    }
}
