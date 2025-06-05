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
            print("-------------------------")
        
        
        // Rohen JSON-String ausgeben
        if let jsonString = String(data: data, encoding: .utf8) {
            print("--- RAW JSON RESPONSE ---")
            print(jsonString)
            print("-------------------------")
        } else {
            print("--- UNABLE TO CONVERT DATA TO STRING ---")
        }

        // Prüfen, ob der Status Code 200 ist. Wenn nicht, Fehler werfen.
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
            print("--- RAW JSON RESPONSE ---")
            print(jsonString)
            print("-------------------------")
        } else {
            print("--- UNABLE TO CONVERT DATA TO STRING ---")
        }

        if let httpResponse = response as? HTTPURLResponse {
            print("--- HTTP STATUS CODE ---")
            print(httpResponse.statusCode)
            print("-------------------------")
        }
        
//        if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode >= 400 {
//            throw HTTPError.badResponse
//        }
        
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
            print("-------------------------")
        } else {
            print("--- UNABLE TO CONVERT DATA TO STRING ---")
        }

        if let httpResponse = response as? HTTPURLResponse {
            print("--- HTTP STATUS CODE ---")
            print(httpResponse.statusCode)
            print("-------------------------")
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
