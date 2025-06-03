//
//  PlantRepository.swift
//  PlantApp
//
//  Created by Alexandra Jäger on 26.05.25.
//

import Foundation


protocol PlantRepository {
    
    func fetchPlantsList() async throws -> [Plant]
    
    func fetchPlantSuggestions(for query: String) async throws -> [Plant]
    
    func fetchPlantsByName(for query: String) async throws -> [Plant]
//
//    func getPlantDetails() async throws -> Plant
    
}
