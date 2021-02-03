//
//  UserDefaults.swift
//  Exchanges
//
//  Created by Jakub Kalamarz on 01/02/2021.
//

import Foundation

final class Defaults {
    static let shared = Defaults()

    private let keyFavorites = "favorites"
    private let userDefaults = UserDefaults.standard
    private let keyBase = "base"
    private let defaultBase = "PLN"
}
//MARK:: Favorites methods
extension Defaults {
    func getFavorites() -> [String] {
        if let favorites = userDefaults.array(forKey: keyFavorites) as? [String] {
            return favorites
        } else {
            userDefaults.set([], forKey: keyFavorites)
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
        userDefaults.set(array, forKey: keyFavorites)
    }
}

//MARK:: Base methods
extension Defaults {
    func getBase() -> String {
        if let base = userDefaults.string(forKey: keyBase) {
            return base
        } else {
            userDefaults.setValue(defaultBase, forKey: keyBase)
            return defaultBase
        }
    }

    func setBase(base: String) {
        userDefaults.setValue(base, forKey: keyBase)
    }
}
