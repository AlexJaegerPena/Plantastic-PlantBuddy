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
    
    private let plantRepository: PlantRepository
    
    init(plantRepository: PlantRepository) {
        self.plantRepository = plantRepository
    }
    
    func apiPlantsList() {
        Task {
            do {
                let response = try await plantRepository.getPlantsList()
                self.plants = Array(response.prefix(10))
                for plant in plants {
                    print("Plant ID: \(plant.id), Common Name: \(plant.commonName ?? "Unknown") ")
                }
            } catch {
                print(error)
            }
        }
    }
    

    
//    func getPlantByName() {
//        Task {
//            do {
//                self.plants = try await plantRepository.getPlantSuggestions(for: searchTerm)
//            } catch {
//                print(error)
//            }
//        }
//    }
    
}
