//
//  UserDefaultManager.swift
//  Drinks
//
//  Created by M Usman on 23/04/2024.
//

import Foundation


class UserDefaultManager {
    static let shared = UserDefaultManager()
    private init(){}
    func savelastSearchType(isSearchByAlphabet:Bool) {
        UserDefaults.standard.set(isSearchByAlphabet, forKey: "session.SearchType")
    }
    func getIsSearchByAlphabet()->Bool{
        let defaults = UserDefaults.standard
        let value = defaults.bool(forKey: "session.SearchType")
        return value
    }
}
