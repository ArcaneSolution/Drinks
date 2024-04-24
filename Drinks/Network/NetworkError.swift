//
//  NetworkError.swift
//  Drinks
//
//  Created by M Usman on 23/04/2024.
//

import Foundation
enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case requestFailed(Error)
    case decodingFailed(Error)
}
