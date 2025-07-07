//
//  Plant.swift
//  PlantApp
//
//  Created by Alexandra Jäger on 26.05.25.
//

import Foundation

struct PlantResponse: Codable {
    let data: [Plant]
}

struct Plant: Codable, Identifiable {
    let id: Int
    let commonName: String
    let scientificName: [String]
    let otherName: [String]?
    let family: String?
    let genus: String?
    let defaultImage: PlantImages?

    enum CodingKeys: String, CodingKey {
        case id
        case commonName = "common_name"
        case scientificName = "scientific_name"
        case otherName = "other_name"
        case genus
        case family
        case defaultImage = "default_image"
    }
}

extension Plant {
    init(from plant: Plant) {
        self.id = plant.id
        self.commonName = plant.commonName
        self.scientificName = plant.scientificName
        self.otherName = plant.otherName
        self.family = plant.family
        self.genus = plant.genus
        self.defaultImage = plant.defaultImage
    }
}

struct PlantImages: Codable {
    let originalUrl: String?
    let regularUrl: String?
    let mediumUrl: String?
    let smallUrl: String?
    let thumbnail: String?

    enum CodingKeys: String, CodingKey {
        case originalUrl = "original_url"
        case regularUrl = "regular_url"
        case mediumUrl = "medium_url"
        case smallUrl = "small_url"
        case thumbnail
    }
}

struct PlantDetails: Codable, Identifiable {
    let id: Int
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
    let harvestSeason: [String]?
    let leaf: Bool?
    let edibleLeaf: Bool?
    let attracts: [String]?
    let hardiness: Hardiness?

    enum CodingKeys: String, CodingKey {
        case id
        case commonName = "common_name"
        case scientificName = "scientific_name"
        case family
        case genus
        case type
        case dimensions
        case watering
        //        case wateringBenchmark = "watering_general_benchmark"
        case sunlight
        case cycle
        case defaultImage = "default_image"
        case indoor
        case cuisine
        case poisonousToHumans = "poisonous_to_humans"
        case poisonousToPets = "poisonous_to_pets"
        case description
        case soil
        case origin
        case pruningMonth = "pruning_month"
        case invasive
        case careLevel = "care_level"
        case fruits
        case edibleFruit = "edible_fruit"
        case harvestSeason = "harvest_season"
        case leaf
        case edibleLeaf = "edible_leaf"
        case attracts
        case hardiness
    }
}

struct Hardiness: Codable {
    let min: String
    let max: String
}

struct DimensionItem: Codable {
    let minValue: Double?
    let maxValue: Double?
    let unit: String?

    enum CodingKeys: String, CodingKey {
        case minValue = "min_value"
        case maxValue = "max_value"
        case unit
    }
}

//struct WateringBenchmark: Codable {
//    let value: String
//    let unit: String
//}

enum Watering: String, Codable {
    case Frequent
    case Average
    case Minimum
    case None

    var icon: String {
        switch self {
        case .None: return "🚫"
        default: return "💧"
        }
    }

    var dropCount: Int {
        switch self {
        case .Frequent: return 3
        case .Average: return 2
        case .Minimum: return 1
        case .None: return 0
        }
    }

    var nextWatering: Double {
        switch self {
        case .Frequent: return 2
        case .Average: return 5
        case .Minimum: return 10
        case .None: return 0
        }
    }
}

//{
//    "id":1,
//    "common_name":"European Silver Fir",
//    "scientific_name":["Abies alba"],
//    "other_name":["Common Silver Fir"],
//    "family":null,
//    "hybrid":null,
//    "authority":null,
//    "subspecies":null,
//    "cultivar":null,
//    "variety":null,
//    "species_epithet":"alba",
//    "genus":"Abies",
//    "origin":["Austria","Germany","Switzerland","France","Italy","Slovenia","Croatia","Bosnia and Herzegovina","Serbia","Montenegro","Albania","Bulgaria","Romania","Ukraine","Poland","Czech Republic","Slovakia","Hungary"],
//    "type":"tree",
//    "dimensions":[{"type":"Height","min_value":60,"max_value":60,"unit":"feet"}],
//    "cycle":"Perennial",
//    "attracts":[],
//    "propagation":["Cutting","Grafting Propagation","Layering Propagation","Seed Propagation","Air Layering Propagation","Tissue Culture"],
//    "hardiness":{"min":"7","max":"7"},
//    "hardiness_location":{"full_url":"https:\/\/perenual.com\/api\/hardiness-map?species_id=1&size=og&key=sk-kHxH683433840b40110663","full_iframe":"<iframe frameborder=0 scrolling=yes seamless=seamless width=1000 height=550 style='margin:auto;' src='https:\/\/perenual.com\/api\/hardiness-map?species_id=1&size=og&key=sk-kHxH683433840b40110663'><\/iframe>"},
//    "watering":"Frequent",
//    "watering_general_benchmark":{"value":"\"7-10\"","unit":"days"},
//    "plant_anatomy":[],
//    "sunlight":["full sun"],
//    "pruning_month":["February","March","April"],
//    "pruning_count":[],
//    "seeds":false,
//    "maintenance":null,
// "care_guides":"http:\/\/perenual.com\/api\/species-care-guide-list?species_id=1&key=sk-kHxH683433840b40110663",
//    "soil":[],
//    "growth_rate":"High",
//    "drought_tolerant":false,
//    "salt_tolerant":false,
//    "thorny":false,
//    "invasive":false,
//    "tropical":false,
//    "indoor":false,
//    "care_level":"Medium",
//    "pest_susceptibility":[],
//    "flowers":false,
//    "flowering_season":null,
//    "cones":true,
//    "fruits":false,
//    "edible_fruit":false,
//    "harvest_season":null,
//    "leaf":true,
//    "edible_leaf":false,
//    "cuisine":false,
//    "medicinal":true,
//    "poisonous_to_humans":false,
//    "poisonous_to_pets":false,
//    "description":"European Silver Fir (Abies alba) is an amazing coniferous species native to mountainous regions of central Europe and the Balkans. It is an evergreen tree with a narrow, pyramidal shape and long, soft needles. Its bark is scaly grey-brown and its branches are highly ornamental due to its conical-shaped silver-tinged needles. It is pruned for use as an ornamental evergreen hedging and screening plant, and is also popular for use as a Christmas tree. Young trees grow quickly and have strong, flexible branches which makes them perfect for use as windbreaks. The European Silver Fir is an impressive species, making it ideal for gardens and public spaces.",
//    "default_image":{"license":45,"license_name":"Attribution-ShareAlike 3.0 Unported (CC BY-SA 3.0)","license_url":"https:\/\/creativecommons.org\/licenses\/by-sa\/3.0\/deed.en","original_url":"https:\/\/perenual.com\/storage\/species_image\/1_abies_alba\/og\/1536px-Abies_alba_SkalitC3A9.jpg","regular_url":"https:\/\/perenual.com\/storage\/species_image\/1_abies_alba\/regular\/1536px-Abies_alba_SkalitC3A9.jpg","medium_url":"https:\/\/perenual.com\/storage\/species_image\/1_abies_alba\/medium\/1536px-Abies_alba_SkalitC3A9.jpg","small_url":"https:\/\/perenual.com\/storage\/species_image\/1_abies_alba\/small\/1536px-Abies_alba_SkalitC3A9.jpg","thumbnail":"https:\/\/perenual.com\/storage\/species_image\/1_abies_alba\/thumbnail\/1536px-Abies_alba_SkalitC3A9.jpg"}
//   }

//{
//    "data": [
//        {
//            "id": 1,
//            "common_name": "European Silver Fir",
//            "scientific_name": [
//                "Abies alba"
//            ],
//            "other_name": [
//                "Common Silver Fir"
//            ],
//            "family": null,
//            "hybrid": null,
//            "authority": null,
//            "subspecies": null,
//            "cultivar": null,
//            "variety": null,
//            "species_epithet": "alba",
//            "genus": "Abies",
//            "default_image": {
//                "image_id": 9,
//                "license": 5,
//                "license_name": "Attribution-ShareAlike License",
//                "license_url": "https://creativecommons.org/licenses/by-sa/2.0/",
//                "original_url": "https://perenual.com/storage/species_image/2_abies_alba_pyramidalis/og/49255769768_df55596553_b.jpg",
//                "regular_url": "https://perenual.com/storage/species_image/2_abies_alba_pyramidalis/regular/49255769768_df55596553_b.jpg",
//                "medium_url": "https://perenual.com/storage/species_image/2_abies_alba_pyramidalis/medium/49255769768_df55596553_b.jpg",
//                "small_url": "https://perenual.com/storage/species_image/2_abies_alba_pyramidalis/small/49255769768_df55596553_b.jpg",
//                "thumbnail": "https://perenual.com/storage/species_image/2_abies_alba_pyramidalis/thumbnail/49255769768_df55596553_b.jpg"
//            }
//        },
//        {
//            "id": 2,
//            "common_name": "Pyramidalis Silver Fir",
//            "scientific_name": [
//                "Abies alba 'Pyramidalis'"
//            ],
//            "other_name": null,
//            "family": null,
//            "hybrid": null,
//            "authority": null,
//            "subspecies": null,
//            "cultivar": "Pyramidalis",
//            "variety": null,
//            "species_epithet": "alba",
//            "genus": "Abies",
//            "default_image": {
//                "image_id": 9,
//                "license": 5,
//                "license_name": "Attribution-ShareAlike License",
//                "license_url": "https://creativecommons.org/licenses/by-sa/2.0/",
//                "original_url": "https://perenual.com/storage/species_image/2_abies_alba_pyramidalis/og/49255769768_df55596553_b.jpg",
//                "regular_url": "https://perenual.com/storage/species_image/2_abies_alba_pyramidalis/regular/49255769768_df55596553_b.jpg",
//                "medium_url": "https://perenual.com/storage/species_image/2_abies_alba_pyramidalis/medium/49255769768_df55596553_b.jpg",
//                "small_url": "https://perenual.com/storage/species_image/2_abies_alba_pyramidalis/small/49255769768_df55596553_b.jpg",
//                "thumbnail": "https://perenual.com/storage/species_image/2_abies_alba_pyramidalis/thumbnail/49255769768_df55596553_b.jpg"
//            }
//        }
//        ...
//    ],
//    "to": 30,
//    "per_page": 30,
//    "current_page": 1,
//    "from": 1,
//    "last_page": 405,
//    "total": 10104
//}
