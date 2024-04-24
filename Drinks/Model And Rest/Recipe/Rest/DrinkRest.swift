//
//  DrinkRest.swift
//  Drinks
//
//  Created by M Usman on 23/04/2024.
//

import Foundation


class DrinkRest {
    static func getDrinksByName(name:String)->NetworkRequest<String,DrinkResponseModel>{
        let httpModel = NetworkRequest<String,DrinkResponseModel>(
            method: .get,
            url: URLSettings.searchByName(name: name)
        )
        return httpModel
    }
    static func getDrinksByAlphabet(firstAlphabet:String)->NetworkRequest<String,DrinkResponseModel>{
        let httpModel = NetworkRequest<String,DrinkResponseModel>(
            method: .get,
            url: URLSettings.searchByAlphabet(firstAlphabet: firstAlphabet)
        )
        return httpModel
    }
}
