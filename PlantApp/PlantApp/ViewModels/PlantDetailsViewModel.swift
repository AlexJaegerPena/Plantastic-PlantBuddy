//
//  PlantDetailsViewModel.swift
//  PlantApp
//
//  Created by Alexandra Jäger on 04.06.25.
//

import Foundation


@MainActor
class PlantDetailsViewModel: ObservableObject {
    @Published var plantDetails: PlantDetails? = nil
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private let plantId: Int
    private let plantRepository: PlantRepository
    
    init(plantId: Int, plantRepository: PlantRepository) {
        self.plantId = plantId
        self.plantRepository = plantRepository
    }
    
    func fetchPlantByID(_ id: Int) {
        guard !isLoading else { return } // Verhindert doppeltes Laden
        
        isLoading = true
        errorMessage = nil
        
        Task {
            defer { isLoading = false} // Stellt sicher, dass isLoading immer auf false gesetzt wird
            do {
                self.plantDetails = try await plantRepository.fetchPlantDetailsByID(id)
                print("Fetched Plant Details for ID \(id): \(self.plantDetails?.commonName ?? "N/A")")
            } catch {
                print(error)
            }
        }
    }
    
    
    
}
