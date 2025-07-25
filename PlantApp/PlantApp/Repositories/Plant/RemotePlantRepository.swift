//
//  RemotePlantRepository.swift
//  PlantApp
//
//  Created by Alexandra Jäger on 26.05.25.
//

import Foundation

class RemotePlantRepository: PlantRepository {

    private let speciesListURL = "https://perenual.com/api/v2/species-list"
    private let detailsURL = "https://perenual.com/api/v2/species/details/"
    

    func fetchPlantsList() async throws -> [Plant] {
        // Endpunkt Deklarieren
        let urlString = "\(speciesListURL)?key=\(plantApiKey)"
    
        // URL verifizieren
        guard let url = URL(string: urlString) else {
            throw HTTPError.invalidURL
        }
        // Daten von API ziehen (wird ein String sein)
        let (data, response) = try await URLSession.shared.data(from: url)
        
        // HTTP Response Status Code überprüfen und behandeln
        guard let httpResponse = response as? HTTPURLResponse else {
              throw HTTPError.badResponse
          }
        
        // ------- Debugging --------
        // Status Code ausgeben
            print("--- HTTP STATUS CODE ---")
            print(httpResponse.statusCode)
        
        // Rohen JSON-String ausgeben
        if let jsonString = String(data: data, encoding: .utf8) {
            print("RAW JSON RESPONSE")
            print(jsonString)

        } else {
            print("Unable to convert data to string")
        }

        // Prüfen, ob der Status Code 200 ist. Wenn nicht, Fehler werfen
            guard httpResponse.statusCode == 200 else {
                throw HTTPError.badResponse
            }
        
        // Bekommene Daten in gewünschtes Objekt decodieren
        let plantResponse = try JSONDecoder().decode(PlantResponse.self, from: data)
        
        return plantResponse.data
    }
    
    
    func fetchPlantsByQuery(_ query: String ) async throws -> [Plant] {
        
        // Endpunkt Deklarieren
        let urlString = "\(speciesListURL)?key=\(plantApiKey)&q=\(query)"
        
        // URL verifizieren
        guard let url = URL(string: urlString) else {
            throw HTTPError.invalidURL
        }
        
        // Daten von API ziehen (wird ein String sein)
        let (data, response) = try await URLSession.shared.data(from: url)
        
        // Debugging: Rohen JSON-String ausgeben
        if let jsonString = String(data: data, encoding: .utf8) {
            print("RAW JSON RESPONSE")
            print(jsonString)
        } else {
            print("Unable to convert data to string")
        }
        
        if let httpResponse = response as? HTTPURLResponse {
            if httpResponse.statusCode == 200 {
                print("Status Code: \(httpResponse.statusCode)")
            } else {
                if let responseString = String(data: data, encoding: .utf8) {
                    print("Error Response: \(responseString)")
                }
                throw HTTPError.badResponse
            }
        }
        // Bekommene Daten in gewünschtes Objekt decodieren
        let plantResponse = try JSONDecoder().decode(PlantResponse.self, from: data)
        
        return plantResponse.data
    }
    
    
    func fetchPlantDetailsByID(_ id: Int ) async throws -> PlantDetails {
        
        // Endpunkt Deklarieren
        let urlString = "\(detailsURL)\(id)?key=\(plantApiKey)"
          
        // URL verifizieren
        guard let url = URL(string: urlString) else {
            throw HTTPError.invalidURL
        }
        
        // Daten von API ziehen (wird ein String sein)
        let (data, response) = try await URLSession.shared.data(from: url)
        
        // Debugging: Rohen JSON-String ausgeben
        if let jsonString = String(data: data, encoding: .utf8) {
            print("--- RAW JSON RESPONSE ---")
            print(jsonString)
        } else {
            print("Unable to convert data to string")
        }

        if let httpResponse = response as? HTTPURLResponse {
            print("--- HTTP STATUS CODE ---")
            print(httpResponse.statusCode)
        }
        
        if let httpResponse = response as? HTTPURLResponse {
            if httpResponse.statusCode == 200 {
                print("Status Code: \(httpResponse.statusCode)")
            } else {
                if let responseString = String(data: data, encoding: .utf8) {
                    print("Error Response: \(responseString)")
                }
                throw HTTPError.badResponse
            }
        }
        
        // Bekommene Daten in gewünschtes Objekt decodieren
        let plantResponse = try JSONDecoder().decode(PlantDetails.self, from: data)
        
        return plantResponse
    }
    
    
}
