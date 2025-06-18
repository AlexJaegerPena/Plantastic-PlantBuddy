//
//  PlantLocation.swift
//  PlantApp
//
//  Created by Alexandra Jäger on 18.06.25.
//

import Foundation


struct PlantLocation: Identifiable {
    let id: UUID = UUID()
    let name: String
    let plants: [FirePlant]
}
