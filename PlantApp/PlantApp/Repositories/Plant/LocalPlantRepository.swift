//
//  LocalPlantRepository.swift
//  PlantApp
//
//  Created by Alexandra Jäger on 26.05.25.
//

import Foundation


class LocalPlantRepository: PlantRepository {
    
    @Published var favoritePlants: [FirePlant] = []
    
    
    func fetchPlantsList() async throws -> [Plant] {
        return dummyPlantData.sorted { $0.commonName < $1.commonName }
    }
    
    
    func fetchPlantDetailsByID(_ id: Int) async throws -> PlantDetails {
        return dummyPlantDetail
    }
    
    
    func fetchPlantsByQuery(_ query: String) async throws -> [Plant] {
        guard !query.isEmpty else {
            return []
        }
        let filteredPlants = dummyPlantData.filter { plant in
            plant.commonName.lowercased().hasPrefix(query.lowercased())
        }
        return filteredPlants
    }
    
    func addPlantToFav(newPlant: FirePlant) {
        favoritePlants.append(newPlant)
    }
    
    func removePlantFromFav(plant: FirePlant) {
        favoritePlants.removeAll(where: { $0.id == plant.id } )
    }
    
    
    func fetchFavPlants() -> [FirePlant] {
        return favoritePlants
    }
    
    
    
    
    
    // ------- Dummy Data -------
    
    private var dummyPlantData: [Plant] = [
        Plant(
            id: 1,
            commonName: "European Silver Fir",
            scientificName: ["Abies alba"],
            otherName: ["Common Silver Fir"],
            family: nil, // Original JSON hat null für 'family'
            genus: "Abies",
            defaultImage: PlantImages(
                originalUrl: "https://perenual.com/storage/species_image/1_abies_alba/og/1536px-Abies_alba_SkalitC3A9.jpg",
                regularUrl: "https://perenual.com/storage/species_image/1_abies_alba/regular/1536px-Abies_alba_SkalitC3A9.jpg",
                mediumUrl: "https://perenual.com/storage/species_image/1_abies_alba/medium/1536px-Abies_alba_SkalitC3A9.jpg",
                smallUrl: "https://perenual.com/storage/species_image/1_abies_alba/small/1536px-Abies_alba_SkalitC3A9.jpg",
                thumbnail: "https://perenual.com/storage/species_image/1_abies_alba/thumbnail/1536px-Abies_alba_SkalitC3A9.jpg"
            )
        ),
        Plant(
            id: 2,
            commonName: "Pyramidalis Silver Fir",
            scientificName: ["Abies alba 'Pyramidalis'"],
            otherName: [],
            family: nil, // Original JSON hat null für 'family'
            genus: "Abies",
            defaultImage: PlantImages(
                originalUrl: "https://perenual.com/storage/species_image/2_abies_alba_pyramidalis/og/49255769768_df55596553_b.jpg",
                regularUrl: "https://perenual.com/storage/species_image/2_abies_alba_pyramidalis/regular/49255769768_df55596553_b.jpg",
                mediumUrl: "https://perenual.com/storage/species_image/2_abies_alba_pyramidalis/medium/49255769768_df55596553_b.jpg",
                smallUrl: "https://perenual.com/storage/species_image/2_abies_alba_pyramidalis/small/49255769768_df55596553_b.jpg",
                thumbnail: "https://perenual.com/storage/species_image/2_abies_alba_pyramidalis/thumbnail/49255769768_df55596553_b.jpg"
            )
        ),
        Plant(
            id: 3,
            commonName: "White Fir",
            scientificName: ["Abies concolor"],
            otherName: ["Silver Fir", "Concolor Fir", "Colorado Fir"],
            family: "Pinaceae",
            genus: "Abies",
            defaultImage: PlantImages(
                originalUrl: "https://perenual.com/storage/species_image/3_abies_concolor/og/52292935430_f4f3b22614_b.jpg",
                regularUrl: "https://perenual.com/storage/species_image/3_abies_concolor/regular/52292935430_f4f3b22614_b.jpg",
                mediumUrl: "https://perenual.com/storage/species_image/3_abies_concolor/medium/52292935430_f4f3b22614_b.jpg",
                smallUrl: "https://perenual.com/storage/species_image/3_abies_concolor/small/52292935430_f4f3b22614_b.jpg",
                thumbnail: "https://perenual.com/storage/species_image/3_abies_concolor/thumbnail/52292935430_f4f3b22614_b.jpg"
            )
        ),
        Plant(
            id: 4,
            commonName: "Candicans White Fir",
            scientificName: ["Abies concolor 'Candicans'"],
            otherName: ["Silver Fir", "Concolor Fir", "Colorado Fir"],
            family: nil, // Original JSON hat null für 'family'
            genus: "Abies",
            defaultImage: PlantImages(
                originalUrl: "https://perenual.com/storage/species_image/4_abies_concolor_candicans/og/49283844888_332c9e46f2_b.jpg",
                regularUrl: "https://perenual.com/storage/species_image/4_abies_concolor_candicans/regular/49283844888_332c9e46f2_b.jpg",
                mediumUrl: "https://perenual.com/storage/species_image/4_abies_concolor_candicans/medium/49283844888_332c9e46f2_b.jpg",
                smallUrl: "https://perenual.com/storage/species_image/4_abies_concolor_candicans/small/49283844888_332c9e46f2_b.jpg",
                thumbnail: "https://perenual.com/storage/species_image/4_abies_concolor_candicans/thumbnail/49283844888_332c9e46f2_b.jpg"
            )
        ),
        Plant(
            id: 5,
            commonName: "Fraser Fir",
            scientificName: ["Abies fraseri"],
            otherName: ["Southern Fir"],
            family: "Pinaceae",
            genus: "Abies",
            defaultImage: PlantImages(
                originalUrl: "https://perenual.com/storage/species_image/5_abies_fraseri/og/36843539702_e80fc436e0_b.jpg",
                regularUrl: "https://perenual.com/storage/species_image/5_abies_fraseri/regular/36843539702_e80fc436e0_b.jpg",
                mediumUrl: "https://perenual.com/storage/species_image/5_abies_fraseri/medium/36843539702_e80fc436e0_b.jpg",
                smallUrl: "https://perenual.com/storage/species_image/5_abies_fraseri/small/36843539702_e80fc436e0_b.jpg",
                thumbnail: "https://perenual.com/storage/species_image/5_abies_fraseri/thumbnail/36843539702_e80fc436e0_b.jpg"
            )
        ),
        Plant(
            id: 6,
            commonName: "Golden Korean Fir",
            scientificName: ["Abies koreana 'Aurea'"],
            otherName: [],
            family: "Pinaceae",
            genus: "Abies",
            defaultImage: PlantImages(
                originalUrl: "https://perenual.com/storage/species_image/6_abies_koreana_aurea/og/49235570926_99ec10781d_b.jpg",
                regularUrl: "https://perenual.com/storage/species_image/6_abies_koreana_aurea/regular/49235570926_99ec10781d_b.jpg",
                mediumUrl: "https://perenual.com/storage/species_image/6_abies_koreana_aurea/medium/49235570926_99ec10781d_b.jpg",
                smallUrl: "https://perenual.com/storage/species_image/6_abies_koreana_aurea/small/49235570926_99ec10781d_b.jpg",
                thumbnail: "https://perenual.com/storage/species_image/6_abies_koreana_aurea/thumbnail/49235570926_99ec10781d_b.jpg"
            )
        ),
        Plant(
            id: 7,
            commonName: "Alpine Fir",
            scientificName: ["Abies lasiocarpa"],
            otherName: ["Subalpine Fir", "Rocky Mountain Fir"],
            family: "Pinaceae",
            genus: "Abies",
            defaultImage: PlantImages(
                originalUrl: "https://perenual.com/storage/species_image/7_abies_lasiocarpa/og/51002756843_74fae3c2fa_b.jpg",
                regularUrl: "https://perenual.com/storage/species_image/7_abies_lasiocarpa/regular/51002756843_74fae3c2fa_b.jpg",
                mediumUrl: "https://perenual.com/storage/species_image/7_abies_lasiocarpa/medium/51002756843_74fae3c2fa_b.jpg",
                smallUrl: "https://perenual.com/storage/species_image/7_abies_lasiocarpa/small/51002756843_74fae3c2fa_b.jpg",
                thumbnail: "https://perenual.com/storage/species_image/7_abies_lasiocarpa/thumbnail/51002756843_74fae3c2fa_b.jpg"
            )
        ),
        Plant(
            id: 8,
            commonName: "Blue Spanish Fir",
            scientificName: ["Abies pinsapo 'Glauca'"],
            otherName: ["Glaucous Spanish Fir"],
            family: "Pinaceae",
            genus: "Abies",
            defaultImage: PlantImages(
                originalUrl: "https://perenual.com/storage/species_image/8_abies_pinsapo_glauca/og/21657514018_c0d9fed9f4_b.jpg",
                regularUrl: "https://perenual.com/storage/species_image/8_abies_pinsapo_glauca/regular/21657514018_c0d9fed9f4_b.jpg",
                mediumUrl: "https://perenual.com/storage/species_image/8_abies_pinsapo_glauca/medium/21657514018_c0d9fed9f4_b.jpg",
                smallUrl: "https://perenual.com/storage/species_image/8_abies_pinsapo_glauca/small/21657514018_c0d9fed9f4_b.jpg",
                thumbnail: "https://perenual.com/storage/species_image/8_abies_pinsapo_glauca/thumbnail/21657514018_c0d9fed9f4_b.jpg"
            )
        ),
        Plant(
            id: 9,
            commonName: "Noble Fir",
            scientificName: ["Abies procera"],
            otherName: ["Red Fir", "White Fir"],
            family: "Pinaceae",
            genus: "Abies",
            defaultImage: PlantImages(
                originalUrl: "https://perenual.com/storage/species_image/9_abies_procera/og/49107504112_6bd7effb8b_b.jpg",
                regularUrl: "https://perenual.com/storage/species_image/9_abies_procera/regular/49107504112_6bd7effb8b_b.jpg",
                mediumUrl: "https://perenual.com/storage/species_image/9_abies_procera/medium/49107504112_6bd7effb8b_b.jpg",
                smallUrl: "https://perenual.com/storage/species_image/9_abies_procera/small/49107504112_6bd7effb8b_b.jpg",
                thumbnail: "https://perenual.com/storage/species_image/9_abies_procera/thumbnail/49107504112_6bd7effb8b_b.jpg"
            )
        )
    ]
    
    private var dummyPlantDetail: PlantDetails = PlantDetails(
        id: 1,
        commonName: "European Silver Fir",
        scientificName: ["Abies alba"],
        family: "", // JSON hat ""
        genus: "Abies",
        type: "tree",
        dimensions: [DimensionItem(
            minValue: 1,
            maxValue: 1.5,
            unit: "feet"
        )],
        watering: Watering(rawValue: "Frequent"),
//        wateringBenchmark: WateringBenchmark(
//            value: "5 - 7",
//            unit: "days"
//        ),
        sunlight: ["Part shade"],
        cycle: "Perennial",
        defaultImage: PlantImages(
            originalUrl: "https://perenual.com/storage/species_image/2678_abies_alba_pyramidalis/og/49255768_df596553_b.jpg",
            regularUrl: "https://perenual.com/storage/species_image/2678_abies_alba_pyramidalis/regular/4925769768f55596553_b.jpg",
            mediumUrl: "https://perenual.com/storage/species_image/882_abies_alba_pyramidalis/medium/4925576768_f55596553_b.jpg",
            smallUrl: "https://perenual.com/storage/species_image/2678_abies_alba_pyramidalis/small/492557668_df55596553_b.jpg",
            thumbnail: "https://perenual.com/storage/species_image/2786_abies_alba_pyramidalis/thumbnail/4929768_df55553_b.jpg"
        ),
        indoor: false,
        cuisine: false,
        poisonousToHumans: false,
        poisonousToPets: false,
        description: "Amazing garden plant that is sure to capture attention...",
        soil: [], // JSON hat ein leeres Array
        origin: nil, // JSON hat null
        pruningMonth: ["March", "April"],
        invasive: false,
        careLevel: "Medium",
        fruits: false,
        edibleFruit: false,
        harvestSeason: nil, // JSON hat null
        leaf: true,
        edibleLeaf: false,
        attracts: ["bees", "birds", "rabbits"],
        hardiness: Hardiness(min: "7", max: "7")
    )
    
    
}

