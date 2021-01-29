//
//  Rates.swift
//  Exchanges
//
//  Created by Jakub Kalamarz on 28/01/2021.
//

import Foundation

class Rates: Codable {
    let base: String
    let rates: [String: Double]
}
