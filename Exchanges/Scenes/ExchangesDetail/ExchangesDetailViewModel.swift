//
//  ExchangesDetailViewModel.swift
//  Exchanges
//
//  Created by Jakub Kalamarz on 28/01/2021.
//

import Foundation

class ExchangesDetailViewModel {
    @Published var base:String

    init(rate: Rate) {
        self.base = rate.currency
    }
}
