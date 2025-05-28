//
//  RemotePlantRepository.swift
//  PlantApp
//
//  Created by Alexandra Jäger on 26.05.25.
//

import Foundation

class RemotePlantRepository: PlantRepository {

    private let speciesListURL = "https://perenual.com/api/v2/species-list"    
    private let apiKey = "sk-kHxH683433840b40110663"

    func getPlantsList() async throws -> [Plant] {

        // Endpunkt Deklarieren
        let urlString = "\(speciesListURL)?key=\(apiKey)"
        
        // URL verifizieren
        guard let url = URL(string: urlString) else {
            throw HTTPError.invalidURL
        }

        // Daten von API ziehen (wird ein String sein)
        let (data, response) = try await URLSession.shared.data(from: url)

        if let httpResponse = response as? HTTPURLResponse {
            if httpResponse.statusCode == 200 {
                print("Status Code: \(httpResponse.statusCode)")
                if let responseString = String(data: data, encoding: .utf8) {
                    print("Error Response: \(responseString)")
                }
                throw HTTPError.badResponse
            }
        }
        
        
        // Bekommene Daten in gewünschtes Objekt decodieren
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let plantResponse = try decoder.decode(PlantResponse.self, from: data)

        return plantResponse.data

    }

    //    func getPlantSuggestions(for query: String) async throws -> [Plant] {
    //
    //        guard !query.isEmpty else { return [] }
    //
    //        let urlString = "\(baseURL)-list?key=\(apiKey)&order=asc"
    //
    //        guard let url = URL(string:urlString) else { throw HTTPError.invalidURL }
    //
    //        let (data, response) = try await URLSession.shared.data(from: url)
    //
    //        if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode >= 400 {
    //            throw HTTPError.badResponse
    //        }
    //
    //        let plantResponse = try JSONDecoder().decode(PlantResponse.self, from: data)
    //        return plantResponse.data.plant
    //    }

//    func getPlantDetails() async throws -> Plant {
//        return
//    }

}
