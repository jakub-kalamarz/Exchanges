//
//  ExchangesListCoordinator.swift
//  Exchanges
//
//  Created by Jakub Kalamarz on 28/01/2021.
//

import Combine
import UIKit

protocol ExchangesFlow {
    func coordinateToDetail(to currency: Rate)
}

class ExchangesListCoordinator: Coordinator {
    let navigationController: UINavigationController

    var canncelables = Set<AnyCancellable>()

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let view = ExchangesListView()
        let viewModel = ExchangesListViewModel()
        view.viewModel = viewModel
        navigationController.pushViewController(view, animated: true)

        viewModel.selectedCurrency.sink(receiveValue: { item in
            self.coordinateToDetail(to: item)
        })
            .store(in: &canncelables)
    }
}

extension ExchangesListCoordinator: ExchangesFlow {
    func coordinateToDetail(to currency: Rate) {
        let coordinator = ExchangesDetailCoordinator(navigationController: navigationController, rate: currency)
        coordinate(to: coordinator)
    }
}
