//
//  ExchangesListViewModel.swift
//  Exchanges
//
//  Created by Jakub Kalamarz on 28/01/2021.
//

import Foundation
import Combine

enum ExchangesListViewModelState{
    case loading
    case finishedLoading
    case error(Error)
}

class ExchangesListViewModel {
    var network: ExchangesApi

    @Published var title = "Exchanges"
    @Published var data = [Rate]()
    @Published var state: ExchangesListViewModelState = .loading

    var selectedCurrency = PassthroughSubject<Rate, Never>()

    private var canncelables = Set<AnyCancellable>()

    init(network: ExchangesApi = ExchangesApi()) {
        self.network = network

        getRatesList()

    }

    private func getRatesList() {
        state = .loading

        network.getRatesList()
            .sink(receiveCompletion: { error in
                print(error)
            }, receiveValue: { value in
                var data = value.rates.map { Rate(currency: $0.key, value: $0.value) }
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
