//
//  Date+LastWeek.swift
//  Exchanges
//
//  Created by Jakub Kalamarz on 31/01/2021.
//

import Foundation

extension Calendar {
    func getLastWeekDay(_ format: String = "YYYY-MM-DD", dayOfWeek: Int = 2) -> String {
        let now = Date()
        let formater = DateFormatter()
        formater.dateFormat = format

        var lastDay = Calendar.current.dateComponents([.weekOfYear, .year], from: now)
        if lastDay.weekOfYear == 1 {
            lastDay.year! -= 1
            lastDay.weekOfYear = 1
        } else {
            lastDay.weekOfYear! -= 1
        }

        lastDay.weekday = dayOfWeek
        let lastDayDate = date(from: lastDay)

        return formater.string(from: lastDayDate!)
    }

    func getToday(_ format: String = "YYYY-MM-DD") -> String {
        let now = Date()
        let formater = DateFormatter()
        formater.dateFormat = format

        return formater.string(from: now)
    }

    func getDateFromString(string: String, format: String = "YYYY-MM-DD") -> Date? {
        let formater = DateFormatter()
        formater.dateFormat = format

        return formater.date(from: string)
    }

    func getStringFromDate(date: Date, format: String = "DD.MM") -> String {
        let formater = DateFormatter()
        formater.dateFormat = format

        return formater.string(from: date)
    }

}
