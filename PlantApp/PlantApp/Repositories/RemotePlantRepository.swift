//
//  RemotePlantRepository.swift
//  PlantApp
//
//  Created by Alexandra Jäger on 26.05.25.
//

import Foundation

class RemotePlantRepository: PlantRepository {

    private let speciesListURL = "https://perenual.com/api/v2/species-list"    

    
    func fetchPlantsList() async throws -> [Plant] {
        // Endpunkt Deklarieren
        let urlString = "\(speciesListURL)?key=\(plantApiKey)"
        
        // URL verifizieren
        guard let url = URL(string: urlString) else {
            throw HTTPError.invalidURL
        }

        // Daten von API ziehen (wird ein String sein)
        let (data, response) = try await URLSession.shared.data(from: url)

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
    
    
    func fetchPlantsByName(for query: String ) async throws -> [Plant] {
        
        // Endpunkt Deklarieren
        let urlString = "\(speciesListURL)?key=\(plantApiKey)&q=\(query)"
        
        // URL verifizieren
        guard let url = URL(string: urlString) else {
            throw HTTPError.invalidURL
        }
        
        // Daten von API ziehen (wird ein String sein)
        let (data, response) = try await URLSession.shared.data(from: url)
        
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

    
        func fetchPlantSuggestions(for query: String) async throws -> [Plant] {
            guard !query.isEmpty else { return [] }
            
            let urlString = "\(speciesListURL)-list?key=\(plantApiKey)&order=asc"
            
            guard let url = URL(string:urlString) else { throw HTTPError.invalidURL }
    
            let (data, response) = try await URLSession.shared.data(from: url)
    
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode >= 400 {
                throw HTTPError.badResponse
            }
            let plantResponse = try JSONDecoder().decode(PlantResponse.self, from: data)
            return plantResponse.data
        }
    
    
    

//    func fetchPlantDetails() async throws -> Plant {
//        return
//    }

}
