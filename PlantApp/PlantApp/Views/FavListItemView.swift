//
//  FavListItemView.swift
//  PlantApp
//
//  Created by Alexandra Jäger on 13.06.25.
//

import FirebaseCore
import SwiftUI

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
                        .frame(width: 80, height: 80)
                        .clipShape(RoundedRectangle(cornerRadius: 25))
                        .shadow(color: .black.opacity(0.2), radius: 2, x: 3, y: 3)
                } placeholder: {
                    Image("placeholderPlant")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80, height: 80)
                        .clipShape(RoundedRectangle(cornerRadius: 25))
                        .foregroundColor(.gray)
                }
                .padding(5)
                VStack(alignment: .leading, spacing: 5) {
                    Text(plant.commonName.lowercased().trimmingCharacters(in: .whitespacesAndNewlines).capitalized)
                        .font(.system(size: 18))
                        .fontWeight(.semibold)
                        .foregroundStyle(Color("textColor"))
                    
                    Text(plant.userCategory?.rawValue ?? "")
                        .padding(.bottom, 3)
                        .font(.system(size: 14))
                        .foregroundStyle(.gray)
                    
                    HStack {
                        Text(plant.wateringStatusText)
                    }
                    .font(.system(size: 12))
                    .padding(.vertical, 5)
                    .foregroundStyle(plant.needsToBeWatered ? Color("textColorInverted") : Color("textColor").opacity(0.7))
                    .padding(.horizontal, 10)
                    .background(plant.needsToBeWatered ? Color("textColor") : Color("textColor").opacity(0.2))
                    .clipShape(RoundedRectangle(cornerRadius: 20))
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
                    Image(systemName: plant.needsToBeWatered ? "drop.fill" : "checkmark")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 25, height: 25)
                        .foregroundStyle(plant.needsToBeWatered ? Color("textColorInverted") : Color("textColor").opacity(0.7))
                        .padding(12)
                        .background {
                            Circle()
                                .fill(isClicked ? Color("secondaryColor") :  (plant.needsToBeWatered ? Color("textColor") : Color("textColor").opacity(0.2)) )
                    }
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
            dimensions: [
                DimensionItem(minValue: 1, maxValue: 1.5, unit: "feet")
            ],
            watering: .Frequent,
            sunlight: ["Part shade"],
            cycle: "Perennial",
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
