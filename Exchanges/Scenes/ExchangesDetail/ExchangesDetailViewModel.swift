//
//  ExchangesDetailViewModel.swift
//  Exchanges
//
//  Created by Jakub Kalamarz on 28/01/2021.
//

import Foundation
import Combine

class ExchangesDetailViewModel {
    var network: ExchangesApi

    @Published var symbol:String

    @Published var data: [Rate] = [Rate]()

    private var canncelables = Set<AnyCancellable>()

    var title: String {
        self.symbol
    }

    init(network: ExchangesApi = ExchangesApi(), rate: Rate) {
        self.symbol = rate.currency
        self.network = network

        getRatesPeriod()
    }

    private func getRatesPeriod() {
        network.getRatesPeriod(symbol: symbol)
            .sink(receiveCompletion: { error in
                print(error)
            }, receiveValue: { value in
                self.data = value.rates.map { data in
                    let date = Calendar.current.getDateFromString(string: data.key)!
                    let rate = data.value.values.first!
                    let base = data.value.keys.first!
                    return Rate(currency: base, value: rate, date: date)
                }
            })
            .store(in: &canncelables)
    }
}
