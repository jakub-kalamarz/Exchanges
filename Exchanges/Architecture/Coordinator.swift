//
//  Coordinator.swift
//  Exchanges
//
//  Created by Jakub Kalamarz on 28/01/2021.
//

import UIKit

protocol Coordinator {
    func start()
    func coordinate(to coordinator: Coordinator)
}

extension Coordinator {
    func coordinate(to coordinator: Coordinator) {
        coordinator.start()
    }
}
