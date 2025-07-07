//
//  HTTPError.swift
//  PlantApp
//
//  Created by Alexandra Jäger on 26.05.25.
//

import Foundation

enum HTTPError: String, Error {
    case invalidURL = "URL is not valid."
    case badResponse = "Statuscode >= 400"
}
