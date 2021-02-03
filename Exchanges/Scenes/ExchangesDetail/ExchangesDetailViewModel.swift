//
//  ExchangesDetailViewModel.swift
//  Exchanges
//
//  Created by Jakub Kalamarz on 28/01/2021.
//

import Combine
import Foundation

class ExchangesDetailViewModel {
    var network: ExchangesApi

    @Published var symbol: String
    @Published var data = [Rate]()
    @Published var isFavorite: Bool
    @Published var base: String

    let markAsFavorite = PassthroughSubject<Void, Never>()

    private var canncelables = Set<AnyCancellable>()

    var title: String {
        symbol
    }

    init(network: ExchangesApi = ExchangesApi(), rate: Rate) {
        self.symbol = rate.currency
        self.isFavorite = rate.isFavorite
        self.base = rate.base
        self.network = network

        markAsFavorite.sink(receiveValue: { [self] _ in
            self.isFavorite.toggle()
            Defaults.shared.addOrDeleteFavorites(currency: symbol)
        })
            .store(in: &canncelables)

        getRatesPeriod()
    }

    private func getRatesPeriod() {
        network.getRatesPeriod(symbol: symbol)
            .sink(receiveCompletion: { error in
                print(error)
            }, receiveValue: { value in
                let favoritesArray = Defaults.shared.getFavorites()
                var data = value.rates.map { data -> Rate in
                    let date = Calendar.current.getDateFromString(string: data.key)!
                    let rate = data.value.values.first!
                    let base = value.base
                    let symbol = data.value.keys.first!
                    return Rate(currency: symbol, value: rate, isFavorite: favoritesArray.contains(symbol), date: date, base: base)
                }
                data.sort(by: { first, second in
                    first.date < second.date
                })
                self.data = data
            })
            .store(in: &canncelables)
    }
}
