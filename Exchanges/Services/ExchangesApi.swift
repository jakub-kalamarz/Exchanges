//
//  ExchangesApi.swift
//  Exchanges
//
//  Created by Jakub Kalamarz on 28/01/2021.
//

import Combine
import Foundation

enum Symbol: String {
    case PLN
    case USD
    case EUR
    case GBP
}

final class ExchangesApi {
    static let shared = ExchangesApi()

    var urlSession = URLSession.shared

    func getRatesList() -> AnyPublisher<Rates, Error> {
        let base = Defaults.shared.getBase()

        let url = URL(string: "https://api.exchangeratesapi.io/latest?base=\(base)")!

        return urlSession.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: Rates.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }

    func getRatesPeriod(symbol: String) -> AnyPublisher<CurrencyRates, Error> {
        let today = Calendar.current.getToday()
        let lastWeekMonday = Calendar.current.getLastWeekDay()
        let base = Defaults.shared.getBase()

        let url = URL(string: "https://api.exchangeratesapi.io/history?start_at=\(lastWeekMonday)&end_at=\(today)&symbols=\(symbol)&base=\(base)")!

        return urlSession.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: CurrencyRates.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}
