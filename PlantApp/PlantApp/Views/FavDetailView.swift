//
//  FavDetailView.swift
//  PlantApp
//
//  Created by Alexandra Jäger on 17.06.25.
//

import SwiftUI

struct FavDetailView: View {

    let selectedPlantId: String

    @State private var isClicked = false
    @State private var showWateringMessage = false
    @State private var selectedCategory: UserCategory?
    @State private var isDescriptionExpanded = false

    
    @EnvironmentObject var userViewModel: UserViewModel
    @EnvironmentObject var favPlantViewModel: FavPlantViewModel


    var body: some View {
        Group {
            if favPlantViewModel.isLoading {
                ProgressView("Loading Plant Details...")
                    .font(.headline)
                    .padding()
            } else if favPlantViewModel.selectedFavPlant == nil {
                ContentUnavailableView(
                    "Plant Not Found",
                    systemImage: "leaf.fill",
                    description: Text(
                        "The details for this plant could not be loaded.")
                )
            } else {
                if let plant = favPlantViewModel.selectedFavPlant {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 20) {

                            // --- Plant Image Header ---
                            ZStack(alignment: .bottomTrailing) {
                                AsyncImage(url: URL(string: plant.defaultImage?.originalUrl ?? plant.defaultImage?.thumbnail ?? "")) { image in
                                    image
                                        .resizable()
                                        .scaledToFill()
                                        .frame(
                                            maxWidth: .infinity,
                                            minHeight: 250, maxHeight: 250
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
                                            maxWidth: .infinity,
                                            minHeight: 250, maxHeight: 300
                                        )
                                        .cornerRadius(20)
                                        .overlay(ProgressView())
                                }
                                .padding(.horizontal, 15)

                                // --- Watering Info & Button ---
                                Button {
                                    showWateringMessage = true
                                    isClicked = true
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                                        isClicked = false
                                        Task {
                                            await favPlantViewModel.addWatering(for: plant, with: plant.id)
                                        }
                                    }
                                } label: {
                                    VStack(alignment: .center, spacing: 8) {
                                        Image("canBW")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 45, height: 45)
                                    }
                                    .padding(.vertical, 12)
                                    .padding(.horizontal, 16)
                                    .background {
                                        if #available(iOS 26.0, *) {
                                            Circle()
                                                .fill(Color.clear)
                                                .glassEffect(in: Circle())
                                                .overlay {
                                                    Circle().stroke(
                                                        plant.needsToBeWatered ? Color("signalColor") : Color("secondaryPetrol"),
                                                        lineWidth: isClicked ? 4 : 3
                                                    )
                                                    .opacity(isClicked ? 1.0 : 0.35)
                                                }
                                        } else {
                                            Circle()
                                                .fill(.ultraThinMaterial)
                                                .overlay {
                                                    Circle().stroke(
                                                        plant.needsToBeWatered ? Color("signalColor") : Color("secondaryPetrol"),
                                                        lineWidth: isClicked ? 4 : 3
                                                    )
                                                    .opacity(isClicked ? 1.0 : 0.35)
                                                }
                                        }
                                    }

                                    .shadow(
                                        color: isClicked
                                            ? Color("secondaryPetrol")
                                            : (plant.needsToBeWatered
                                                ? Color("signalColor").opacity(
                                                    0.4)
                                                : Color("secondaryPetrol")
                                                    .opacity(0.4)),
                                        radius: 1, x: 2, y: 2
                                    )
                                }
                                .scaleEffect(isClicked ? 1.2 : 1.0)
                                .animation(
                                    .spring(
                                        response: 0.3, dampingFraction: 0.4,
                                        blendDuration: 0), value: isClicked
                                )
                                .alert(
                                    !plant.needsToBeWatered ? "Oops!" : "Nice!",
                                    isPresented: $showWateringMessage
                                ) {
                                    Button("OK", role: .cancel) {}
                                } message: {
                                    Text(
                                        !plant.needsToBeWatered
                                            ? "The timing wasn't ideal. Keep an eye on the next watering date."
                                            : "Perfect timing! The watering was just right."
                                    )
                                }
                                .padding(.trailing, 20)
                                .padding(.bottom, 10)
                            }

                            // --- Description ---
                            if let description = plant.description, !description.isEmpty {
                                SectionHeader(title: "Description", icon: "info.bubble.fill.rtl")

                                VStack(alignment: .leading, spacing: 8) {
                                    Text(description)
                                        .font(.body)
                                        .foregroundStyle(Color("textColor"))
                                        .lineSpacing(4)
                                        .lineLimit(isDescriptionExpanded ? nil : 5)
                                        .truncationMode(.tail)
                                        .animation(.easeInOut(duration: 0.2), value: isDescriptionExpanded)

                                    Button {
                                        isDescriptionExpanded.toggle()
                                    } label: {
                                        HStack(spacing: 6) {
                                            Text(isDescriptionExpanded ? "Show less" : "Read more")
                                                .font(.subheadline)
                                                .fontWeight(.semibold)

                                            Image(systemName: isDescriptionExpanded ? "chevron.up" : "chevron.down")
                                                .font(.subheadline)
                                        }
                                    }
                                    .buttonStyle(.plain)
                                    .foregroundStyle(Color("primaryPetrol"))
                                    .padding(.top, 4)
                                }
                                .padding(.horizontal)
                            }

                            Divider().padding(.horizontal)

                            // --- Info Cards ---
                            SectionHeader(
                                title: "Facts & Care",
                                icon: "clipboard.fill")
                            VStack(alignment: .leading, spacing: 15) {
                                HStack(spacing: 15) {
                                    FactCard(
                                        icon: { Text("✋") },
                                        title: "Care Level",
                                        value: plant.careLevel ?? "N/A"
                                    )
                                    FactCard(
                                        icon: {
                                            if let watering = plant.watering {
                                                (WateringIndicatorView(
                                                    watering: watering))
                                            } else {
                                                Text("no info")
                                            }
                                        },
                                        title: "Watering",
                                        value: plant.watering?.rawValue
                                            ?? "N/A"
                                    )
                                    FactCard(
                                        icon: { Text("☀️") },
                                        title: "Sunlight",
                                        value: plant.sunlight?.first
                                            ?? "N/A"
                                    )
                                }
                                .padding(.horizontal)

                                HStack(spacing: 15) {
                                    FactCard(
                                        icon: {
                                            Text(
                                                plant.indoor == true ? "🏠" : "🌳"
                                            )
                                        },
                                        title: "Location",
                                        value: plant.indoor == true
                                            ? "Indoor" : "Outdoor"
                                    )
                                    FactCard(
                                        icon: { Text("⚠️") },
                                        title: "Poisonous (Human)",
                                        value: plant.poisonousToHumans
                                            == true ? "Yes" : "No"
                                    )
                                    FactCard(
                                        icon: { Text("⚠️") },
                                        title: "Poisonous (Pets)",
                                        value: plant.poisonousToPets == true
                                            ? "Yes" : "No"
                                    )
                                }
                                .padding(.horizontal)
                            }
                            Divider().padding(.horizontal)

                            // --- General Info ---
                            SectionHeader(
                                title: "General Info",
                                icon: "info.circle.fill")
                            VStack(alignment: .leading, spacing: 10) {
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
                                    value: plant.soil?.joined(
                                        separator: ", "))
                                InfoRow(
                                    icon: "scissors",
                                    title: "Pruning Month",
                                    value: plant.pruningMonth?.joined(
                                        separator: ", "))
                            }
                            .padding(.horizontal)

                            Divider().padding(.horizontal)

                            // --- Additional Info ---
                            SectionHeader(
                                title: "Additional Info", icon: "star.fill")
                            VStack(alignment: .leading, spacing: 10) {
                                InfoRow(
                                    icon: "exclamationmark.triangle",
                                    title: "Invasive",
                                    value: plant.invasive == true
                                        ? "Yes" : "No")
                                InfoRow(
                                    icon: "carrot.fill", title: "Fruits",
                                    value: plant.fruits == true
                                        ? "Yes" : "No")
                                InfoRow(
                                    icon: "fork.knife",
                                    title: "Edible Fruit",
                                    value: plant.edibleFruit == true
                                        ? "Yes" : "No")
                                InfoRow(
                                    icon: "leaf.fill", title: "Leaf",
                                    value: plant.leaf == true ? "Yes" : "No"
                                )
                                InfoRow(
                                    icon: "carrot.fill",
                                    title: "Edible Leaf",
                                    value: plant.edibleLeaf == true
                                        ? "Yes" : "No")
                                InfoRow(
                                    icon: "calendar",
                                    title: "Harvest Season",
                                    value: plant.harvestSeason)
                            }
                            .padding(.horizontal)
                        }
                        .padding(.bottom, 20)
                    }
                    .navigationTitle(plant.commonName.lowercased()
                        .trimmingCharacters(
                            in: .whitespacesAndNewlines
                        ).capitalized)
                    .foregroundStyle(Color("textColor"))
                    .navigationBarTitleDisplayMode(.large)
                    .toolbar {
                        ToolbarItem(placement: .topBarTrailing) {
                            Menu {
                                ForEach(UserCategory.allCases.filter { $0 != .all }) { category in
                                    Button {
                                        selectedCategory = category
                                        Task {
                                            var updatedPlant = plant
                                            updatedPlant.userCategory = category
                                            await favPlantViewModel.updatePlant(for: updatedPlant, with: updatedPlant.id)
                                        }
                                    } label: {
                                        Label(category.rawValue, systemImage: category.icon)
                                    }
                                    .tint(Color("textColor"))
                                }
                            } label: {
                                Image(systemName: selectedCategory?.icon ?? "tag")
                            }
                            .tint(Color("textColor"))

                        }
                    }
                }
            }
        }
        .onAppear {
            print(
                "FavPlantViewModel - onAppear: selectedPlantId = \(selectedPlantId)"
            )
            Task {
                await favPlantViewModel.loadSelectedFav(selectedPlantId)
                if let plant = favPlantViewModel.selectedFavPlant {
                    selectedCategory = plant.userCategory ?? .unmarked
                }
            }
        }
    }
}

#Preview {
    FavDetailView(selectedPlantId: "1")
        .environmentObject(FavPlantViewModel())
}
