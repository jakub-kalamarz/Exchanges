//
//  ExchangesApi.swift
//  Exchanges
//
//  Created by Jakub Kalamarz on 28/01/2021.
//

import Foundation
import Combine

enum Symbol: String {
    case PLN = "PLN"
    case USD = "USD"
    case EUR = "EUR"
    case GBP = "GBP"
}

final class ExchangesApi {

    static let shared = ExchangesApi()

    var urlSession = URLSession.shared

    func getRatesList(for base: Symbol = .PLN) -> AnyPublisher<Rates, Error> {

        let url = URL(string: "https://api.exchangeratesapi.io/latest?base=\(base)")!

        return urlSession.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: Rates.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}
