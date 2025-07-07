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
    let watering: Watering?
//    let wateringBenchmark: WateringBenchmark?
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
    let harvestSeason: String?
    let leaf: Bool?
    let edibleLeaf: Bool?
    let attracts: [String]?
    let hardiness: Hardiness?
    var lastWaterDate: Date?
    var nextWaterDate: Date?
    
    // needsToBeWatered als Computed Property
    var needsToBeWatered: Bool {
        // Sicherstellen, dass ein nextWaterDate existiert, wenn nicht wird true gesetzt
        guard let nextWaterDate = self.nextWaterDate else {
               return true
        }
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date()) // Start des heutigen Tages (00:00 Uhr)
        let nextWateringDay = calendar.startOfDay(for: nextWaterDate) // Start des nextWaterDate (00:00 Uhr)

        // needsToBeWatered ist true, wenn heute >= nächster Bewässerungstag ist
        return today >= nextWateringDay
    }
    
    var wateringStatusText: String {
        if needsToBeWatered {
            return "Needs water"
        } else if let nextWaterDate = self.nextWaterDate {
            let calendar = Calendar.current
            let today = calendar.startOfDay(for: Date())
            let nextWateringDay = calendar.startOfDay(for: nextWaterDate)
            
            let components = calendar.dateComponents([.day], from: today, to: nextWateringDay)
            
            if let days = components.day {
                if days == 0 {
                    return "today"
                } else if days == 1{
                 return "tomorrow"
                } else if days >= 2 {
                    return "in \(days) days"
                }
            }
        }
        return "No watering info"
    }
    
    
    
    var waterings: [WateringRecord]?
    var timesWatered: Int?
    var userCategory: UserCategory?

    
    // Konstruktor, um ein FirePlant-Objekt aus den API-Daten von PlantDetails zu erzeugen
    init(from plantDetails: PlantDetails) {
        self.apiPlantId = plantDetails.id
        self.commonName = plantDetails.commonName
        self.scientificName = plantDetails.scientificName
        self.family = plantDetails.family
        self.genus = plantDetails.genus
        self.type = plantDetails.type
        self.dimensions = plantDetails.dimensions
        self.watering = plantDetails.watering
//        self.wateringBenchmark = plantDetails.wateringBenchmark
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
        self.lastWaterDate = nil
        self.nextWaterDate = nil
        self.waterings = nil
        self.timesWatered = 0
        self.userCategory = .unmarked
    }
}



// Extension für den custom init mit allen Eigenschaften
extension FirePlant {
    init(
        id: String?,
        apiPlantId: Int,
        commonName: String,
        scientificName: [String],
        family: String?,
        genus: String?,
        type: String?,
        dimensions: [DimensionItem]?,
        watering: Watering?,
//        wateringBenchmark: WateringBenchmark?,
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
        harvestSeason: String?,
        leaf: Bool?,
        edibleLeaf: Bool?,
        attracts: [String]?,
        hardiness: Hardiness?,
//        lastWatering: Date?,
//        needsToBeWatered: Bool,
//        nextWatering: Date,
        waterings: [WateringRecord]?
//        timesWatered: Int?,
//        userCategory: UserCategory?
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
//        self.wateringBenchmark = wateringBenchmark
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
        self.waterings = waterings
        self.timesWatered = self.waterings?.count ?? 0
        self.userCategory = .unmarked
        self.lastWaterDate = waterings?.last?.date // lastWaterDate auf letzted Datum setzen
        
        // nextWaterDate baiserend auf lastWaterDate
        if let lastWaterDate = self.lastWaterDate, let wateringInterval = watering?.nextWatering {
            self.nextWaterDate = Calendar.current.date(byAdding: .day, value: Int(wateringInterval), to: lastWaterDate)
        } else {
            self.nextWaterDate = Calendar.current.date(byAdding: .day, value: 7, to: Date()) // Standardwert 7 Tage
        }
    }
}


enum UserCategory: String, CaseIterable, Identifiable, Codable {
    case all = "All plants"
    case indoor = "Indoor"
    case outdoor = "Outdoor"
    case unmarked = "No category"

    var id: String {
        rawValue
    }
    
    var icon: String {
        switch self {
        case .all: return "list.bullet"
        case .unmarked: return "questionmark.circle"
        case .indoor: return "house.fill"
        case .outdoor: return "tree.fill"
        }
    }
}
