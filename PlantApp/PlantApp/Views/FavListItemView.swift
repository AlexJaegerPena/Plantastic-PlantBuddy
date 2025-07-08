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
    
    @State private var isClicked = false
    @State private var showWateringMessage = false
        
    let plant: FirePlant

    var body: some View {
        VStack {
            HStack {
                AsyncImage(
                    url: URL(string: plant.defaultImage?.thumbnail ?? "")
                ) { image in
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .clipShape(RoundedRectangle(cornerRadius: 18))
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
                    Text(plant.commonName.lowercased().trimmingCharacters(in: .whitespacesAndNewlines).capitalized)
                        .font(.system(size: 18))
                        .fontWeight(.semibold)
                        .foregroundStyle(Color("primaryPetrol"))
                    
                    Text(plant.userCategory?.rawValue ?? "")
                        .padding(.bottom, 3)
                        .font(.system(size: 14))
                        .foregroundStyle(.gray)
                    
                    HStack {
                        Image(systemName: plant.needsToBeWatered ? "drop.triangle" : "drop.fill")
                        Text(plant.wateringStatusText)
                    }
                    .font(.system(size: 16))
                    .padding(.vertical, 5)
                    .foregroundStyle(.white)
                    .padding(.horizontal, 10)
                    .background(plant.needsToBeWatered ? Color("signalColor") : Color("secondaryPetrol").opacity(1))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .padding(.leading, 10)
                
                Spacer()
                
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
                    Image(plant.needsToBeWatered ? "canSignal" : "canPetrol")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 35, height: 35)
                        .padding(12)
                        .background {
                            RoundedRectangle(cornerRadius: 18)
                                .fill(isClicked ? Color("secondaryPetrol") :  (plant.needsToBeWatered ? Color("signalColor") : Color("secondaryPetrol").opacity(0.6)) )
                                .stroke(isClicked ? Color("secondaryPetrol") : (plant.needsToBeWatered ? Color("signalColor").opacity(0.2) : Color("secondaryPetrol").opacity(0.2)), lineWidth: 3)
                        }
                        .shadow(color: isClicked ? Color("secondaryPetrol") : (plant.needsToBeWatered ? .yellow.opacity(0.4) : Color("secondaryPetrol").opacity(0.4)), radius: 1, x: 2, y: 2)
                }
                .padding(.trailing, 10)
                .scaleEffect(isClicked ? 1.2 : 1.0)
                .animation(.spring(response: 0.3, dampingFraction: 0.4, blendDuration: 0), value: isClicked)
                .contentShape(RoundedRectangle(cornerRadius: 18)) // um klickbaren Bereich zu definieren
                .alert(!plant.needsToBeWatered ? "Oops!" : "Nice!", isPresented: $showWateringMessage) {
                    Button("OK", role: .cancel) {}
                } message: {
                    Text(!plant.needsToBeWatered ? "The timing wasn't ideal. Keep an eye on the next watering date." : "Perfect timing! The watering was just right.")
                }
            }
        }
        .background(
            NavigationLink(
                "",
                destination: FavDetailView(selectedPlantId: plant.id ?? "0")
            )
            .opacity(0)
        )
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
            waterings: [WateringRecord(id: "1", date: Date())]
        )
    )
    .environmentObject(FavPlantViewModel())
}

