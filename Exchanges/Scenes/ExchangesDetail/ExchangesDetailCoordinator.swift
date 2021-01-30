//
//  ExchangesDetailCoordinator.swift
//  Exchanges
//
//  Created by Jakub Kalamarz on 28/01/2021.
//

import UIKit

class ExchangesDetailCoordinator: Coordinator {
    weak var navigationController: UINavigationController?

        init(navigationController: UINavigationController) {
            self.navigationController = navigationController
        }

        func start() {
            let view = ExchangesDetailView()
            let viewModel = ExchangesDetailViewModel()
            view.viewModel = viewModel

            navigationController?.pushViewController(view, animated: true)
        }
}
