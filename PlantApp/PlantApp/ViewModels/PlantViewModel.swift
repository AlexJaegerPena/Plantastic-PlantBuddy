//
//  PlantViewModel.swift
//  PlantApp
//
//  Created by Alexandra Jäger on 26.05.25.
//

import Foundation

@MainActor
class PlantViewModel: ObservableObject {
    @Published var plants: [Plant] = []
    @Published var searchTerm: String = ""
    @Published var plantSuggestion: [Plant] = []
    
    private let plantRepository: PlantRepository
    
    init(plantRepository: PlantRepository) {
        self.plantRepository = plantRepository
    }
    
    func apiPlantsList() {
        Task {
            do {
                let response = try await plantRepository.fetchPlantsList()
                self.plants = Array(response.prefix(40))
                for plant in plants {
                    print("Plant ID: \(plant.id), Common Name: \(plant.commonName ?? "Unknown") ")
                }
            } catch {
                print(error)
            }
        }
    }
    
    func fetchPlantSuggestions(for query: String) {
        
    }
    

    
    func searchPlantByName(for query: String) {
        
        Task {
            do {
                let response = try await plantRepository.fetchPlantsByName(for: searchTerm)
//                self.plants = try await plantRepository.fetchPlantSuggestions(for: searchTerm)
            } catch {
                print(error)
            }
        }
    }
    
}
