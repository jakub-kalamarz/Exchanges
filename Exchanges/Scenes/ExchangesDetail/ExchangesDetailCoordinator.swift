//
//  ExchangesDetailCoordinator.swift
//  Exchanges
//
//  Created by Jakub Kalamarz on 28/01/2021.
//

import UIKit

protocol ExchangesFlow {
    func coordinateToDetail(to currency: String)
}

class ExchangesDetailCoordinator: Coordinator {
    weak var navigationController: UINavigationController?

        init(navigationController: UINavigationController) {
            self.navigationController = navigationController
        }

        func start() {
        }
}

extension ExchangesDetailCoordinator: ExchangesFlow {
    func coordinateToDetail(to currency: String) {

    }
}
