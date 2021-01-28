//
//  ExchangesListCoordinator.swift
//  Exchanges
//
//  Created by Jakub Kalamarz on 28/01/2021.
//

import UIKit

class ExchangesListCoordinator: Coordinator {
    let navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let view = ExchangesListView()
        let viewModel = ExchangesListViewModel()
        view.viewModel = viewModel
        navigationController.pushViewController(view, animated: false)
    }
}
