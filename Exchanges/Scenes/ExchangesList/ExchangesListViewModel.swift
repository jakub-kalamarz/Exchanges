//
//  ExchangesListViewModel.swift
//  Exchanges
//
//  Created by Jakub Kalamarz on 28/01/2021.
//

import Foundation
import Combine

class ExchangesListViewModel {
    var network: ExchangesApi

    private var canncelables = Set<AnyCancellable>()

    init(network: ExchangesApi = ExchangesApi()) {
        self.network = network

        network.getRatesList()
            .sink(receiveCompletion: { error in
                print(error)
            }, receiveValue: { value in
                print(value.base)
            })
            .store(in: &canncelables)
    }
}
