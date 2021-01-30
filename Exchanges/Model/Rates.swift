//
//  Rates.swift
//  Exchanges
//
//  Created by Jakub Kalamarz on 28/01/2021.
//

import Foundation

struct Rates: Codable {
    let base: String
    let rates: [String: Double]
}

struct Rate {
    let currency: String
    let value: Double
    var isFavorite: Bool = false
}
