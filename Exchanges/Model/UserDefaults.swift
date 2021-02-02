//
//  UserDefaults.swift
//  Exchanges
//
//  Created by Jakub Kalamarz on 01/02/2021.
//

import Foundation

class Defaults {
    static let shared = Defaults()

    let key = "favorites"
    let userDefaults = UserDefaults.standard

    func getFavorites() -> [String] {
        if let favorites = userDefaults.array(forKey: key) as? [String] {
            return favorites
        } else {
            userDefaults.set([], forKey: key)
        }
        return []
    }

    func addOrDeleteFavorites(currency: String) {
        var array = getFavorites()
        if array.contains(where: { $0 == currency }) {
            array.remove(at: array.firstIndex(of: currency)!)
        } else {
            array.append(currency)
        }
        userDefaults.set(array, forKey: key)
    }
}
