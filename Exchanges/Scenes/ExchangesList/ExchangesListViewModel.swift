//
//  ExchangesListViewModel.swift
//  Exchanges
//
//  Created by Jakub Kalamarz on 28/01/2021.
//

import Combine
import Foundation

enum ExchangesListViewModelState {
    case loading
    case finishedLoading
    case error(Error)
}

class ExchangesListViewModel {
    var network: ExchangesApi

    @Published var title = "Exchanges"
    @Published var data = [Rate]()
    @Published var state: ExchangesListViewModelState = .loading

    lazy var currencySorted: [Rate] = {
        self.data.sorted(by: { first, second in
            first.currency < second.currency
        })
    }()

    var selectedCurrency = PassthroughSubject<Rate, Never>()
    var chooseBase = PassthroughSubject<Void, Never>()
    var selectedBase = PassthroughSubject<String, Never>()

    private var canncelables = Set<AnyCancellable>()

    init(network: ExchangesApi = ExchangesApi()) {
        self.network = network

        getRatesList()

        selectedBase.sink(receiveValue: { value in
            Defaults.shared.setBase(base: value)
            self.reloadData()
        })
            .store(in: &canncelables)
    }

    func reloadData() {
        getRatesList()
    }

    private func getRatesList() {
        state = .loading

        network.getRatesList()
            .sink(receiveCompletion: { error in
                print(error)
            }, receiveValue: { value in
                let favoritesArray = Defaults.shared.getFavorites()
                var data = value.rates.map { data -> Rate in
                    let currency = data.key
                    let rate = data.value
                    let base = value.base
                    return Rate(currency: currency, value: rate, isFavorite: favoritesArray.contains(currency), base: base)
                }
                data.sort(by: { first, second in
                    first.currency < second.currency
                })
                data.sort(by: { first, second in
                    first.isFavorite && !second.isFavorite
                })
                self.data = data
                self.state = .finishedLoading
            })
            .store(in: &canncelables)
    }
}
