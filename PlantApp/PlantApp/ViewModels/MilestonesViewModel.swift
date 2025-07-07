//
//  MilestonesViewModel.swift
//  PlantApp
//
//  Created by Alexandra Jäger on 24.06.25.
//

import Foundation

@MainActor
class MilestonesViewModel: ObservableObject {
    @Published var wateringProgressTotal: Double = 0.0
    @Published var wateringProgressOnePlant: Double = 0.0
    @Published var gardenSize: Double = 0.0
}
