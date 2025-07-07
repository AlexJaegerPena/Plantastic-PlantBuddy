//
//  PlantDetailsView.swift
//  PlantApp
//
//  Created by Alexandra Jäger on 26.05.25.
//

import SwiftUI

struct PlantDetailView: View {

    let selectedPlant: Plant  // API plant
    let selectedPlantId: Int  // API id

    @State private var currentFavFirePlant: FirePlant?
    @State private var isFavorite = false
    @State private var showAddFavAlert = false
    @State private var showDelFavAlert = false
    @State private var showDelSuccessAlert = false
    @State private var isClicked = false

    @StateObject private var plantDetailsViewModel: PlantDetailsViewModel

    @EnvironmentObject var userViewModel: UserViewModel
    @EnvironmentObject var favPlantViewModel: FavPlantViewModel
//    @ObservedObject var plantDetailsViewModel: PlantDetailsViewModel

    // init um @StateObject zu initialisieren
    // _ um Swift zu sagen es soll einmalig initialisieren
    init(selectedPlant: Plant, selectedPlantId: Int) {
        self.selectedPlant = selectedPlant
        self.selectedPlantId = selectedPlantId
        _plantDetailsViewModel = StateObject(wrappedValue: PlantDetailsViewModel(plantId: selectedPlantId))
    }

    
    var body: some View {
        Group {
            if plantDetailsViewModel.isLoading {
                ProgressView("Loading Plant Details...")
                    .font(.headline)
                    .padding()
            } else if let plant = plantDetailsViewModel.plantDetails {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 20) {
                            
                            // ---- Plant Image Header ----
                            ZStack(alignment: .bottomTrailing) {
                                AsyncImage(
                                    url: URL(
                                        string: plant.defaultImage?.originalUrl
                                            ?? plant.defaultImage?.thumbnail
                                            ?? "")
                                ) { image in
                                    image
                                        .resizable()
                                        .scaledToFill()
                                        .frame(
                                            maxWidth: .infinity, minHeight: 250,
                                            maxHeight: 250
                                        )
                                        .clipped()
                                        .cornerRadius(20)
                                        .shadow(
                                            color: .black.opacity(0.2),
                                            radius: 10, x: 0, y: 5)
                                } placeholder: {
                                    Rectangle()
                                        .fill(Color.gray.opacity(0.2))
                                        .frame(
                                            maxWidth: .infinity, minHeight: 250,
                                            maxHeight: 300
                                        )
                                        .cornerRadius(20)
                                        .overlay(ProgressView())
                                }
                                .padding(.horizontal, 15)

                                // ---- Favorite Button ----
                                    Button {
                                        if !isFavorite {
                                            Task {
                                                let plantToAdd = FirePlant(
                                                    from: plant)
                                                await favPlantViewModel
                                                    .addToFavorites(plantToAdd)
                                                await favPlantViewModel
                                                    .loadFavorites()
                                                checkIfFavorite()
                                                showAddFavAlert = true
                                            }
                                        } else {
                                            showDelFavAlert = true
                                        }
                                    } label: {
                                        HStack(spacing: 5) {
                                            Text(isFavorite ? "In your garden" : "Add to garden")
                                            Image(
                                                systemName: isFavorite
                                                ? "xmark" : "plus"
                                            )
                                            .font(.system(size: 20))
                                        }
                                        .padding(.vertical, 20)
                                        .padding(.horizontal, 20)
                                        .foregroundStyle(.white
                                        )
                                        .background(isFavorite
                                            ? Color("secondaryPetrol")
                                            : Color("primaryPetrol")
                                        )
                                        .clipShape(RoundedRectangle(cornerRadius: 12))
                                        .shadow(radius: 5)
                                        .scaleEffect(isClicked ? 1.2 : 1.0)
                                        .animation(.spring(response: 0.3, dampingFraction: 0.4, blendDuration: 0), value: isClicked)
                                    }
                                    .padding(.vertical, 8)
                                    .padding(.horizontal, 20)
                            }

                            // ---- Plant Names ----
                            VStack(alignment: .leading, spacing: 5) {
                                Text(plant.commonName.lowercased().trimmingCharacters(in: .whitespacesAndNewlines).capitalized)
                                    .font(.system(size: 30))
                                    .fontWeight(.semibold)
                                    .lineLimit(2)
                                    .minimumScaleFactor(0.7)
                                    .foregroundStyle(Color("primaryPetrol"))

                                Text(
                                    plant.scientificName.joined(separator: ", ")
                                )
                                .font(.subheadline)
                                .italic()
                                .foregroundStyle(Color("lightGrayColor"))
                                .lineLimit(2)
                            }
                            .padding(.horizontal)

                            // ---- Description ----
                            if let description = plant.description,
                                !description.isEmpty
                            {
                                SectionHeader(
                                    title: "Description",
                                    icon: "info.bubble.fill.rtl")
                                VStack(alignment: .leading, spacing: 8) {
                                    Text(description)
                                        .font(.body)
                                        .foregroundStyle(Color("textColor"))
                                        .lineSpacing(4)
                                }
                                .padding(.horizontal)
                            }

                            Divider().padding(.horizontal)

                            // ---- Info Cards ----
                            SectionHeader(
                                title: "Facts & Care", icon: "clipboard.fill")
                            VStack(alignment: .leading, spacing: 15) {
                                HStack(spacing: 15) {
                                    FactCard(
                                        icon: {Text("✋")},
                                        title: "Care Level",
                                        value: plant.careLevel ?? "N/A"
                                    
                                    )
                                    FactCard(
                                        icon: {
                                            if let watering = plant.watering {
                                                (WateringIndicatorView(watering: watering))
                                             } else {
                                                Text("no info")
                                            }
                                        },
                                        title: "Watering",
                                        value: plant.watering?.rawValue
                                            ?? "N/A"
                                       
                                    )
                                    FactCard(
                                        icon: {Text("☀️")},
                                        title: "Sunlight",
                                        value: plant.sunlight?.first ?? "N/A"
                                   
                                    )
                                }
                                .padding(.horizontal)

                                HStack(spacing: 15) {
                                    FactCard(
                                        icon: {Text(plant.indoor == true ? "🏠" : "🌳")},
                                        title: "Location",
                                        value: plant.indoor == true
                                            ? "Indoor" : "Outdoor"
                                    
                                    )
                                    FactCard(
                                        icon: {Text("⚠️")},
                                        title: "Poisonous (Human)",
                                        value: plant.poisonousToHumans == true
                                            ? "Yes" : "No"
                                  
                                    )
                                    FactCard(
                                        icon: {Text("⚠️")},
                                        title: "Poisonous (Pets)",
                                        value: plant.poisonousToPets == true
                                            ? "Yes" : "No"
                                     
                                    )
                                }
                                .padding(.horizontal)
                            }
                            Divider().padding(.horizontal)

                            // ---- General Info ----
                            SectionHeader(
                                title: "General Info", icon: "info.circle.fill")
                            VStack(alignment: .leading, spacing: 10) {
                                InfoRow(
                                    icon: "leaf.fill", title: "Family",
                                    value: plant.family)
                                InfoRow(
                                    icon: "tree.fill", title: "Genus",
                                    value: plant.genus)
                                InfoRow(
                                    icon: "sparkles", title: "Type",
                                    value: plant.type?.capitalized)
                                InfoRow(
                                    icon: "arrow.triangle.2.circlepath",
                                    title: "Cycle", value: plant.cycle)
                                InfoRow(
                                    icon: "ant.fill", title: "Attracts",
                                    value: plant.attracts?.joined(
                                        separator: ", "
                                    ).capitalized)
                                InfoRow(
                                    icon: "humidity.fill", title: "Soil",
                                    value: plant.soil?.joined(separator: ", "))
                                InfoRow(
                                    icon: "scissors", title: "Pruning Month",
                                    value: plant.pruningMonth?.joined(
                                        separator: ", "))
                            }
                            .padding(.horizontal)

                            Divider().padding(.horizontal)

                            // ---- Additional Info ----
                            SectionHeader(
                                title: "Additional Info", icon: "star.fill")  // Neuer Icon
                            VStack(alignment: .leading, spacing: 10) {
                                InfoRow(
                                    icon: "exclamationmark.triangle",
                                    title: "Invasive",
                                    value: plant.invasive == true ? "Yes" : "No"
                                )
                                InfoRow(
                                    icon: "carrot.fill", title: "Fruits",
                                    value: plant.fruits == true ? "Yes" : "No")
                                InfoRow(
                                    icon: "fork.knife", title: "Edible Fruit",
                                    value: plant.edibleFruit == true
                                        ? "Yes" : "No")
                                InfoRow(
                                    icon: "leaf.fill", title: "Leaf",
                                    value: plant.leaf == true ? "Yes" : "No")
                                InfoRow(
                                    icon: "carrot.fill", title: "Edible Leaf",
                                    value: plant.edibleLeaf == true
                                        ? "Yes" : "No")
                                InfoRow(
                                    icon: "calendar", title: "Harvest Season",
                                    value: plant.harvestSeason)
                            }
                            .padding(.horizontal)
                        }
                        .padding(.bottom, 20)
                    }
            }
            else {
                    ContentUnavailableView(
                        "Plant Not Found",
                        systemImage: "leaf.fill",
                        description: Text(
                            "The details for this plant could not be loaded.")
                    )
            }
        }
        .onAppear {
            print(
                "PlantDetailView - onAppear: selectedPlantId = \(selectedPlantId)"
            )
                Task {
                    try? await Task.sleep(nanoseconds: 300_000_000) // 0.3 Sekunden
                    await plantDetailsViewModel.fetchPlantByID(selectedPlantId)
                }
        }
        .alert("Your Garden Grows! 🪴", isPresented: $showAddFavAlert) {
            Button("Ok", role: .cancel) {}
        } message: {
            Text("Congratulations! This plant is now part of your collection.")
        }
        .alert("Remove this plant?", isPresented: $showDelFavAlert) {
            Button("Cancel", role: .cancel) { showDelFavAlert = false }
            Button("Remove", role: .destructive) {
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
                showDelSuccessAlert = true
            }
            .tint(Color("primaryPetrol"))
        } message: {
            Text("Are you sure you want to remove this plant from your garden?")
        }
        .alert("Plant Removed", isPresented: $showDelSuccessAlert) {
            Button("Ok", role: .cancel) { }
        } message: {
            Text("The plant has been successfully removed from your garden.")
        }
    }

    // Hilfsfunktion, um Favoritenstatus zu überprüfen
    private func checkIfFavorite() {
        if let plantDetails = plantDetailsViewModel.plantDetails {
            // favorisierte Pflanze basierend auf der apiPlantId finden
            currentFavFirePlant = favPlantViewModel.favPlantsList.first {
                favPlant in
                favPlant.apiPlantId == plantDetails.id
            }
            isFavorite = currentFavFirePlant != nil
        }
    }
}

#Preview {
    PlantDetailView(
        selectedPlant: Plant(
            id: 1,
            commonName: "European Silver Fir",
            scientificName: ["Abies alba"], otherName: ["dslfkj"],
            family: "",
            genus: "Abies",
            defaultImage: PlantImages(
                originalUrl:
                    "https://perenual.com/storage/species_image/2678_abies_alba_pyramidalis/og/49255768_df596553_b.jpg",
                regularUrl:
                    "https://perenual.com/storage/species_image/2678_abies_alba_pyramidalis/regular/4925769768f55596553_b.jpg",
                mediumUrl:
                    "https://perenual.com/storage/species_image/882_abies_alba_pyramidalis/medium/4925576768_f55596553_b.jpg",
                smallUrl:
                    "https://perenual.com/storage/species_image/2678_abies_alba_pyramidalis/small/492557668_df55596553_b.jpg",
                thumbnail:
                    "https://perenual.com/storage/species_image/2786_abies_alba_pyramidalis/thumbnail/4929768_df55553_b.jpg"
            )
        ),
        selectedPlantId: 1)
    .environmentObject(UserViewModel())
    .environmentObject(FavPlantViewModel())
}
