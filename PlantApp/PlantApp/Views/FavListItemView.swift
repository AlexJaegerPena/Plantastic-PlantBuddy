//
//  FavListItemView.swift
//  PlantApp
//
//  Created by Alexandra Jäger on 13.06.25.
//

import SwiftUI
import FirebaseCore

struct FavListItemView: View {
    
    @EnvironmentObject var favPlantViewModel: FavPlantViewModel
    
    let plant: FirePlant

    var body: some View {

        HStack {
            AsyncImage(
                url: URL(string: plant.defaultImage?.thumbnail ?? "")
            ) { image in
                image
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .shadow(color: .black.opacity(0.2), radius: 2, x: 3, y: 3)
            } placeholder: {
                Image("placeholderPlant")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .foregroundColor(.gray)
            }
            VStack(alignment: .leading, spacing: 5) {
                Text(plant.commonName)
                    .font(.system(size: 18))
                    .fontWeight(.semibold)

                Text(plant.scientificName.first ?? "")
                    .font(.system(size: 14))
                    .foregroundStyle(.gray)
                    .padding(.bottom, 3)
                Text(plant.family ?? "")
                    .font(.system(size: 14))
                    .padding(.vertical, 4)
                    .padding(.horizontal, 10)
                    .foregroundStyle(.white)
                    .background(
                        (plant.family != nil)
                            ? .cyan.opacity(0.8) : .cyan.opacity(0)
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 20))

            }
            .padding(.leading, 10)
            Spacer()
        }
    }
}

#Preview {
    FavListItemView(
        plant: FirePlant(
            id: "1",
            apiPlantId: 1,
            commonName: "European Silver Fir",
            scientificName: ["Abies alba"],
            family: "",
            genus: "Abies",
            type: "tree",
            dimensions: [DimensionItem(minValue: 1, maxValue: 1.5, unit: "feet")],
            watering: .Frequent,
//            wateringBenchmark: WateringBenchmark(value: "5", unit: "days"),
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
            description: "Amazing garden plant...",
            soil: [],
            origin: nil,
            pruningMonth: ["March", "April"],
            invasive: false,
            careLevel: "Medium",
            fruits: false,
            edibleFruit: false,
            harvestSeason: nil,
            leaf: true,
            edibleLeaf: false,
            attracts: ["bees", "birds"],
            hardiness: Hardiness(min: "7", max: "7"),
            timesWatered: WateringRecord(timestamp: Timestamp(date: Date()))
        )
        )
    .environmentObject(FavPlantViewModel())
}

