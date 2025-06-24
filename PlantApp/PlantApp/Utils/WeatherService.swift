//
//  WeatherService.swift
//  PlantApp
//
//  Created by Alexandra Jäger on 27.05.25.
//

import Foundation


class WeatherService {
    
    private let repository = WeatherRepository()
    
    func getCurrentWeather(for city: String) async throws -> WeatherResponse {
        return try await repository.fetchCurrentWeather(for: city)
    }
}
