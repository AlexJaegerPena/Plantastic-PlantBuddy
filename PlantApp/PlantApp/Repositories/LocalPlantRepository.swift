//
//  LocalPlantRepository.swift
//  PlantApp
//
//  Created by Alexandra Jäger on 26.05.25.
//

import Foundation


class LocalPlantRepository: PlantRepository {
    
    private var dummyPlantData: [Plant] = [
        Plant(
            id: 1,
            commonName: "European Silver Fir",
            scientificName: ["Abies alba"],
            defaultImage: ImageDetails(
                originalUrl: "https://perenual.com/storage/species_image/1_abies_alba/medium/1536px-Abies_alba_SkalitC3A9.jpg",
                regularUrl: "https://perenual.com/storage/species_image/1_abies_alba/regular/1536px-Abies_alba_SkalitC3A9.jpg",
                mediumUrl: "https://perenual.com/storage/species_image/1_abies_alba/medium/1536px-Abies_alba_SkalitC3A9.jpg",
                smallUrl: "https://perenual.com/storage/species_image/1_abies_alba/small/1536px-Abies_alba_SkalitC3A9.jpg",
                thumbnail: "https://perenual.com/storage/species_image/1_abies_alba/thumbnail/1536px-Abies_alba_SkalitC3A9.jpg"
            ),
            genus: "Abies",
            family: "Pinaceae"
        ),
        Plant(
            id: 2,
            commonName: "Pyramidalis Silver Fir",
            scientificName: ["Abies alba 'Pyramidalis'"],
            defaultImage: ImageDetails(
                originalUrl: "https://perenual.com/storage/species_image/2_abies_alba_pyramidalis/medium/49255769768_df55596553_b.jpg",
                regularUrl: "https://perenual.com/storage/species_image/2_abies_alba_pyramidalis/regular/49255769768_df55596553_b.jpg",
                mediumUrl: "https://perenual.com/storage/species_image/2_abies_alba_pyramidalis/medium/49255769768_df55596553_b.jpg",
                smallUrl: "https://perenual.com/storage/species_image/2_abies_alba_pyramidalis/small/49255769768_df55596553_b.jpg",
                thumbnail: "https://perenual.com/storage/species_image/2_abies_alba_pyramidalis/thumbnail/49255769768_df55596553_b.jpg"
            ),
            genus: "Abies",
            family: "Pinaceae"
        ),
        Plant(
            id: 3,
            commonName: "Fiddle Leaf Fig",
            scientificName: ["Ficus lyrata"],
            defaultImage: ImageDetails(
                originalUrl: "https://example.com/fiddle_leaf_fig.jpg",
                regularUrl: "https://example.com/fiddle_leaf_fig_regular.jpg",
                mediumUrl: "https://example.com/fiddle_leaf_fig_medium.jpg",
                smallUrl: "https://example.com/fiddle_leaf_fig_small.jpg",
                thumbnail: "https://example.com/fiddle_leaf_fig_thumbnail.jpg"
            ),
            genus: "Ficus",
            family: "Moraceae"
        ),
        Plant(
            id: 4,
            commonName: "Monstera Deliciosa",
            scientificName: ["Monstera deliciosa"],
            defaultImage: ImageDetails(
                originalUrl: "https://example.com/monstera_deliciosa.jpg",
                regularUrl: "https://example.com/monstera_deliciosa_regular.jpg",
                mediumUrl: "https://example.com/monstera_deliciosa_medium.jpg",
                smallUrl: "https://example.com/monstera_deliciosa_small.jpg",
                thumbnail: "https://example.com/monstera_deliciosa_thumbnail.jpg"
            ),
            genus: "Monstera",
            family: "Araceae"
        )
    ]
    
    
    
//    func getPlants() async throws -> [Plant] {
//        guard let plant =
//        
//            return
//
    
    func getPlantsList() async throws -> [Plant] {

        return dummyPlantData.sorted { $0.commonName! < $1.commonName! }

    }
    
//    func getPlantByName(_ name: String) async throws -> [Plant] {
//        return dummyPlantData.filter { plantToFilter in
//            plantToFilter.commonName.contains(name) ||  plantToFilter.scientificName.contains(name)
//        }
//    }
//
//    func getPlantSuggestions(for query: String) async throws -> [Plant] {
//           return
//    }
//    
//    func getPlantDetails() async throws -> Plant {
//            return
//    }
    
    
}
