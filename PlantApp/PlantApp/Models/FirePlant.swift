//
//  FirePlant.swift
//  PlantApp
//
//  Created by Alexandra Jäger on 10.06.25.
//

import FirebaseFirestore
import Foundation

struct FirePlant: Codable, Identifiable {

    @DocumentID var id: String?

    let apiPlantId: Int
    let commonName: String
    let scientificName: [String]
    let family: String?
    let genus: String?
    let type: String?
    let dimensions: [DimensionItem]?
    let watering: String?
    let wateringBenchmark: WateringBenchmark?
    let sunlight: [String]?
    let cycle: String?
    let defaultImage: PlantImages?
    let indoor: Bool?
    let cuisine: Bool?
    let poisonousToHumans: Bool?
    let poisonousToPets: Bool?
    let description: String?
    let soil: [String]?
    let origin: [String]?
    let pruningMonth: [String]?
    let invasive: Bool?
    let careLevel: String?
    let fruits: Bool?
    let edibleFruit: Bool?
    let harvestSeason: [String]?
    let leaf: Bool?
    let edibleLeaf: Bool?
    let attracts: [String]?
    let hardiness: Hardiness?

    init(from plantDetails: PlantDetails) {
        // Die Firestore Document ID wird zur String-Repräsentation der API-ID
        self.id = String(plantDetails.id)
        self.apiPlantId = plantDetails.id
        self.commonName = plantDetails.commonName
        self.scientificName = plantDetails.scientificName
        self.family = plantDetails.family
        self.genus = plantDetails.genus
        self.type = plantDetails.type
        self.dimensions = plantDetails.dimensions
        self.watering = plantDetails.watering
        self.wateringBenchmark = plantDetails.wateringBenchmark
        self.sunlight = plantDetails.sunlight
        self.cycle = plantDetails.cycle
        self.defaultImage = plantDetails.defaultImage
        self.indoor = plantDetails.indoor
        self.cuisine = plantDetails.cuisine
        self.poisonousToHumans = plantDetails.poisonousToHumans
        self.poisonousToPets = plantDetails.poisonousToPets
        self.description = plantDetails.description
        self.soil = plantDetails.soil
        self.origin = plantDetails.origin
        self.pruningMonth = plantDetails.pruningMonth
        self.invasive = plantDetails.invasive
        self.careLevel = plantDetails.careLevel
        self.fruits = plantDetails.fruits
        self.edibleFruit = plantDetails.edibleFruit
        self.harvestSeason = plantDetails.harvestSeason
        self.leaf = plantDetails.leaf
        self.edibleLeaf = plantDetails.edibleLeaf
        self.attracts = plantDetails.attracts
        self.hardiness = plantDetails.hardiness
    }
}

// Extension für den eigenen init. Im Gegensatz dazu oben der init für PlantDetails
extension FirePlant {
    init(
        id: String? = nil,
        apiPlantId: Int,
        commonName: String,
        scientificName: [String],
        family: String?,
        genus: String?,
        type: String?,
        dimensions: [DimensionItem]?,
        watering: String?,
        wateringBenchmark: WateringBenchmark?,
        sunlight: [String]?,
        cycle: String?,
        defaultImage: PlantImages?,
        indoor: Bool?,
        cuisine: Bool?,
        poisonousToHumans: Bool?,
        poisonousToPets: Bool?,
        description: String?,
        soil: [String]?,
        origin: [String]?,
        pruningMonth: [String]?,
        invasive: Bool?,
        careLevel: String?,
        fruits: Bool?,
        edibleFruit: Bool?,
        harvestSeason: [String]?,
        leaf: Bool?,
        edibleLeaf: Bool?,
        attracts: [String]?,
        hardiness: Hardiness?
    ) {
        self.id = id
        self.apiPlantId = apiPlantId
        self.commonName = commonName
        self.scientificName = scientificName
        self.family = family
        self.genus = genus
        self.type = type
        self.dimensions = dimensions
        self.watering = watering
        self.wateringBenchmark = wateringBenchmark
        self.sunlight = sunlight
        self.cycle = cycle
        self.defaultImage = defaultImage
        self.indoor = indoor
        self.cuisine = cuisine
        self.poisonousToHumans = poisonousToHumans
        self.poisonousToPets = poisonousToPets
        self.description = description
        self.soil = soil
        self.origin = origin
        self.pruningMonth = pruningMonth
        self.invasive = invasive
        self.careLevel = careLevel
        self.fruits = fruits
        self.edibleFruit = edibleFruit
        self.harvestSeason = harvestSeason
        self.leaf = leaf
        self.edibleLeaf = edibleLeaf
        self.attracts = attracts
        self.hardiness = hardiness
    }
}
