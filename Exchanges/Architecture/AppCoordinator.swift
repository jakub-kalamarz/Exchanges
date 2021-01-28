//
//  AppCoordinator.swift
//  Exchanges
//
//  Created by Jakub Kalamarz on 28/01/2021.
//

import UIKit

class AppCoordinator: Coordinator {
    let window: UIWindow

    init(window: UIWindow) {
        self.window = window
    }

    func start() {
        let navigationController = UINavigationController()
        window.rootViewController = navigationController
        window.makeKeyAndVisible()

        let exchangeListCoordinator = ExchangesListCoordinator(navigationController: navigationController)
        coordinate(to: exchangeListCoordinator)
    }
}
