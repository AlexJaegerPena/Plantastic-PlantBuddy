//
//  PlantRepository.swift
//  PlantApp
//
//  Created by Alexandra Jäger on 26.05.25.
//

import Foundation


protocol PlantRepository {
    
    func getPlantsList() async throws -> [Plant]
    
//    func getPlantSuggestions(for query: String) async throws -> [Plant]
//    
//    func getPlantDetails() async throws -> Plant
    
}
