//
//  ExchangesDetailCoordinator.swift
//  Exchanges
//
//  Created by Jakub Kalamarz on 28/01/2021.
//

import UIKit

class ExchangesDetailCoordinator: Coordinator {
    weak var navigationController: UINavigationController?

    var selectedRate: Rate

    init(navigationController: UINavigationController, rate: Rate) {
        self.navigationController = navigationController
        selectedRate = rate
    }

    func start() {
        let view = ExchangesDetailView()
        let viewModel = ExchangesDetailViewModel(rate: selectedRate)
        view.viewModel = viewModel

        navigationController?.pushViewController(view, animated: true)
    }
}
