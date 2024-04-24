//
//  URLSettings.swift
//  Drinks
//
//  Created by M Usman on 23/04/2024.
//

import Foundation

class URLSettings {
    
    public static let domain:String = "thecocktaildb.com"
    public static let PROTOCOL:String = "https" 
    public static let baseURL:String = "\(PROTOCOL)://\(domain)/api/json/v1/1/"
    public static let searchURL:String = "\(baseURL)search.php"
    
    public static func searchByName(name : String) -> String{
        "\(searchURL)?s=\(name)"
    }
    public static func searchByAlphabet(firstAlphabet : String) -> String{
        "\(searchURL)?f=\(firstAlphabet)"
    }
}
