//
//  WeatherRepository.swift
//  PlantApp
//
//  Created by Alexandra Jäger on 27.05.25.
//

import Foundation
import CoreLocation  // Für Koordinaten

class WeatherRepository {
    

    private let baseURL = "https://api.weatherapi.com/v1/"
    
    
    func fetchCurrentWeather(for city: String? = nil, coordinates: CLLocationCoordinate2D? = nil) async throws -> WeatherResponse {
        
        var urlComponents = URLComponents(string: "\(baseURL)/current.json")!
        
        // Füge grundlegende Query-Parameter hinzu
                urlComponents.queryItems = [
                    URLQueryItem(name: "key", value: weatherApiKey)
                ]

        // Endpunkt Deklarieren
        if let city {
            urlComponents.queryItems?.append(URLQueryItem(name: "q", value: city))
        } else if let coords = coordinates {
            urlComponents.queryItems?.append(URLQueryItem(name: "q", value: "\(coords.latitude),\(coords.longitude)"))
        } else {
            // Wenn weder Stadt noch Koordinaten angegeben sind
            throw WeatherAPIError.apiError("Keine Stadt oder Koordinaten für die Wetterabfrage angegeben.")
        }
        
        // URL verifizieren
        guard let url = urlComponents.url else {
                    throw WeatherAPIError.invalidURL
                }
        
        // Daten von API ziehen (wird ein String sein)
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            // HTTP-Antwort überprüfen
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                            let errorData = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                            let errorMessage = (errorData?["error"] as? [String: Any])?["message"] as? String ?? "Unbekannter API-Fehler"
                            throw WeatherAPIError.apiError(errorMessage)
                        }
            
            // Bekommene Daten in gewünschtes Objekt decodieren
            return try JSONDecoder().decode(WeatherResponse.self, from: data)

        } catch let decodingError as DecodingError {
                    throw WeatherAPIError.decodingError(decodingError)
                } catch {
                    throw WeatherAPIError.networkError(error)
                }
    }
    
    
    func fetchWeatherForecast(for city: String? = nil, coordinates: CLLocationCoordinate2D? = nil) async throws -> WeatherForecast {
        
        var urlComponents = URLComponents(string: "\(baseURL)/forecast.json")!
        
        // Füge grundlegende Query-Parameter hinzu
                urlComponents.queryItems = [
                    URLQueryItem(name: "key", value: weatherApiKey),
                    URLQueryItem(name: "days", value: "3"),
                    URLQueryItem(name: "aqi", value: "no"),
                    URLQueryItem(name: "alerts", value: "no")
                ]
        
        // Endpunkt Deklarieren
        if let city {
            urlComponents.queryItems?.append(URLQueryItem(name: "q", value: city))
        } else if let coords = coordinates {
            urlComponents.queryItems?.append(URLQueryItem(name: "q", value: "\(coords.latitude),\(coords.longitude)"))
        } else {
            // Wenn weder Stadt noch Koordinaten angegeben sind
            throw WeatherAPIError.apiError("Keine Stadt oder Koordinaten für die Wetterabfrage angegeben.")
        }
        
        // URL verifizieren
        guard let url = urlComponents.url else {
                    throw WeatherAPIError.invalidURL
                }
        
        // Daten von API ziehen (wird ein String sein)
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            // HTTP-Antwort überprüfen
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                            let errorData = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                            let errorMessage = (errorData?["error"] as? [String: Any])?["message"] as? String ?? "Unbekannter API-Fehler"
                            throw WeatherAPIError.apiError(errorMessage)
                        }
        
            // Bekommene Daten in gewünschtes Objekt decodieren
            return try JSONDecoder().decode(WeatherForecast.self, from: data)

        } catch let decodingError as DecodingError {
                    throw WeatherAPIError.decodingError(decodingError)
                } catch {
                    throw WeatherAPIError.networkError(error)
                }
    }
    
}
