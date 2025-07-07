//
//  WeatherAPIError.swift
//  PlantApp
//
//  Created by Alexandra Jäger on 04.07.25.
//

import Foundation


enum WeatherAPIError: Error, LocalizedError {
    case invalidURL
    case networkError(Error)
    case decodingError(Error)
    case apiError(String)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Die angeforderte URL ist ungültig."
        case .networkError(let error):
            return "Es gab ein Problem mit der Netzwerkverbindung: \(error.localizedDescription)"
        case .decodingError(let error):
            return "Die empfangenen Daten konnten nicht verarbeitet werden: \(error.localizedDescription)"
        case .apiError(let message):
            return "Die Wetter-API hat einen Fehler gemeldet: \(message)"
        }
    }
}
