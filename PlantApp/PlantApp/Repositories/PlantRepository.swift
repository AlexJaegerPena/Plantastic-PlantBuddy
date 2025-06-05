//
//  PlantRepository.swift
//  PlantApp
//
//  Created by Alexandra Jäger on 26.05.25.
//

import Foundation


protocol PlantRepository {
    
    func fetchPlantsList() async throws -> [Plant]
    
    func fetchPlantsByQuery(_ query: String) async throws -> [Plant]

    func fetchPlantDetailsByID(_ id: Int) async throws -> PlantDetails
    
}
