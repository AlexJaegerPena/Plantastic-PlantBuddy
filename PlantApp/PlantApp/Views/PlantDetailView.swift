//
//  PlantDetailsView.swift
//  PlantApp
//
//  Created by Alexandra Jäger on 26.05.25.
//

import SwiftUI

struct PlantDetailView: View {

    let selectedPlant: Plant? // API plant
    let selectedPlantId: Int  // API id
  
    @State private var currentFavFirePlant: FirePlant?
    @State private var isFavorite: Bool = false
    @State private var showAddFavAlert: Bool = false
    @State private var showDelFavAlert: Bool = false
    @State private var showDelSuccess: Bool = false

    @EnvironmentObject var userViewModel: UserViewModel
    @EnvironmentObject var favPlantViewModel: FavPlantViewModel
    @ObservedObject var plantDetailsViewModel: PlantDetailsViewModel

    var body: some View {
        if selectedPlant != nil {
            NavigationStack {
                VStack {
                    ZStack {
                        AsyncImage(
                            url: URL(
                                string: plantDetailsViewModel.plantDetails?
                                    .defaultImage?.thumbnail ?? "")
                        ) { image in
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(width: .infinity, height: 280)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                .shadow(
                                    color: .black.opacity(0.2), radius: 0.5,
                                    x: 3, y: 3)
                            //                    .ignoresSafeArea()
                        } placeholder: {
                            Image("placeholderPlant")
                                .resizable()
                                .scaledToFill()
                                .frame(width: .infinity, height: 280)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                            //                    .ignoresSafeArea()
                        }

                        Button {
                            if !isFavorite {
                                Task {
                                    if let plantDetails = plantDetailsViewModel
                                        .plantDetails
                                    {
                                        let plantToAdd = FirePlant(from: plantDetails)  // Umwandlung in FirePlant
                                        await favPlantViewModel.addToFavorites(plantToAdd)
                                        await favPlantViewModel.loadFavorites()
                                        checkIfFavorite()  // isFavorite Status aktualisieren
                                        showAddFavAlert = true
                                        isFavorite = true
                                    } else {
                                        print(
                                            "Fehler: Pflanze konnte nicht zu Favoriten hinzugefügt werden"
                                        )
                                    }
                                }
                            } else {
                                showDelFavAlert = true
                            }
                        } label: {
                            Image(
                                systemName: isFavorite ? "heart.fill" : "heart"
                            )
                            .font(.system(size: 30))
                            .foregroundStyle(isFavorite ? .green : .white)
                            .padding()
                            .background(.black.opacity(0.2))
                            .clipShape(.circle)
                        }
                        .padding(.leading, 300)
                        .padding(.bottom, 220)
                    }
                    
                    Text(plantDetailsViewModel.plantDetails?.commonName ?? "")
                        .font(.headline)
                    Text(plantDetailsViewModel.plantDetails?.scientificName.joined(separator: ", ") ?? "")
                        .font(.subheadline)
                        .foregroundStyle(.gray)

                    List {
                        Section("info") {
                            Text(
                                "Description: \(plantDetailsViewModel.plantDetails?.description ?? "")"
                            )
                            Text(
                                "Family: \(plantDetailsViewModel.plantDetails?.family ?? "")"
                            )
                            Text(
                                "Genus: \(plantDetailsViewModel.plantDetails?.genus ?? "")"
                            )
                            Text(
                                "Type: \(plantDetailsViewModel.plantDetails?.type ?? "")"
                            )
                            Text(
                                "Cycle: \(plantDetailsViewModel.plantDetails?.cycle ?? "")"
                            )
                            Text(
                                "Attracts: \(plantDetailsViewModel.plantDetails?.attracts?.joined(separator: ", ") ?? "–")"
                            )
                        }

                        Section("Care") {
                            Text(
                                "Care Level: \(plantDetailsViewModel.plantDetails?.careLevel ?? "")"
                            )
                            Text(
                                "Watering: \(plantDetailsViewModel.plantDetails?.watering?.rawValue ?? "–")"
                            )

                            HStack {
                                if let watering = plantDetailsViewModel
                                    .plantDetails?.watering
                                {
                                    WateringIndicatorView(watering: watering)
                                } else {
                                    Text("no watering information")
                                }
                            }
                            Text(
                                "Sunlight: \(plantDetailsViewModel.plantDetails?.sunlight ?? [""])"
                            )
                            Text(
                                "Indoor: \(plantDetailsViewModel.plantDetails?.indoor ?? true)"
                            )
                            Text(
                                "Cuisine: \(plantDetailsViewModel.plantDetails?.cuisine ?? false)"
                            )
                            Text(
                                "poisonousToHumans: \(plantDetailsViewModel.plantDetails?.poisonousToHumans ?? true)"
                            )
                            Text(
                                "poisonousToPets: \(plantDetailsViewModel.plantDetails?.poisonousToHumans ?? true)"
                            )
                            Text(
                                "soil: \(plantDetailsViewModel.plantDetails?.soil ?? [""])"
                            )
                            Text(
                                "origin: \(plantDetailsViewModel.plantDetails?.origin ?? [""])"
                            )
                            Text(
                                "pruningMonth: \(plantDetailsViewModel.plantDetails?.pruningMonth ?? [""])"
                            )
                            Text(
                                "invasive: \(plantDetailsViewModel.plantDetails?.invasive ?? true)"
                            )
                            Text(
                                "fruits: \(plantDetailsViewModel.plantDetails?.fruits ?? false)"
                            )
                            Text(
                                "edibleFruit: \(plantDetailsViewModel.plantDetails?.edibleFruit ?? false)"
                            )
                            Text(
                                "harvestSeason: \(plantDetailsViewModel.plantDetails?.harvestSeason ?? [""])"
                            )
                            Text(
                                "leaf: \(plantDetailsViewModel.plantDetails?.leaf ?? false)"
                            )
                            Text(
                                "edibleLeaf: \(plantDetailsViewModel.plantDetails?.edibleLeaf ?? false)"
                            )
                            //                    Text("hardiness: \(plantDetailsViewModel.plantDetails?.hardiness.min ?? 0)")
                            //                    Text("hardiness: \(plantDetailsViewModel.plantDetails?.hardiness.max ?? 0)")

                        }
                    }
                }
                .onAppear {
                    print("PlantDetailView - onAppear: selectedPlantId = \(selectedPlantId)")
                    plantDetailsViewModel.fetchPlantByID(selectedPlantId)
                }
                .alert("Your Garden Grows!",isPresented: $showAddFavAlert) {
                    Button("Ok", role: .cancel) { }
                } message: {
                    Text("Congratulations! This plant is now part of your collection.")
                }
                .alert(
                    "Delete this plant?",
                    isPresented: $showDelFavAlert
                ) {
                    Button("Cancel", role: .destructive) {
                        showDelFavAlert = false
                    }
                    Button("Delete", role: .cancel) {
                        Task {
                            if let firePlant = currentFavFirePlant,
                                let idToRemove = firePlant.id
                            {
                                await favPlantViewModel.removeFromFavorites(
                                    plantId: idToRemove)
                                await favPlantViewModel.loadFavorites()  // Liste aktualisieren
                                checkIfFavorite()
                            }
                        }
                        showDelFavAlert = false
                        isFavorite = false
                        showDelSuccess = true
                    }
                } message: {
                    Text("Are you sure you want to remove this plant from your garden?")
                }
                .alert("Plant Removed",isPresented: $showDelSuccess) {
                    Button("Ok", role: .cancel) { }
                } message: {
                    Text("The plant has been successfully removed from your garden.")
                }
            }

        } else {
            ProgressView()
            Text("Loading...")
        }

    }

    // Hilfsfunktion, um Favoritenstatus zu überprüfen
    private func checkIfFavorite() {
        if let plantDetails = plantDetailsViewModel.plantDetails {
            // favorisierte Pflanze basierend auf der apiPlantId finden
            currentFavFirePlant = favPlantViewModel.favPlantsList.first { favPlant in
                favPlant.apiPlantId == plantDetails.id
            }
            isFavorite = currentFavFirePlant != nil
        }
    }
}

#Preview {
    PlantDetailView(
        selectedPlant: Plant(id: 1,
                             commonName: "European Silver Fir",
                             scientificName: ["Abies alba"], otherName: ["dslfkj"],
                             family: "",
                             genus: "Abies",
                             defaultImage: PlantImages(
                                 originalUrl: "https://perenual.com/storage/species_image/2678_abies_alba_pyramidalis/og/49255768_df596553_b.jpg",
                                 regularUrl: "https://perenual.com/storage/species_image/2678_abies_alba_pyramidalis/regular/4925769768f55596553_b.jpg",
                                 mediumUrl: "https://perenual.com/storage/species_image/882_abies_alba_pyramidalis/medium/4925576768_f55596553_b.jpg",
                                 smallUrl: "https://perenual.com/storage/species_image/2678_abies_alba_pyramidalis/small/492557668_df55596553_b.jpg",
                                 thumbnail: "https://perenual.com/storage/species_image/2786_abies_alba_pyramidalis/thumbnail/4929768_df55553_b.jpg"
                             )
                         ),
        selectedPlantId: 1,
        plantDetailsViewModel: PlantDetailsViewModel(plantId: 1)
    )
    .environmentObject(UserViewModel())
    .environmentObject(FavPlantViewModel())
}
