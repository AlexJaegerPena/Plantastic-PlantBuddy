//
//  PlantDetailsView.swift
//  PlantApp
//
//  Created by Alexandra Jäger on 26.05.25.
//

import SwiftUI

struct PlantDetailView: View {
    
    let selectedPlantId: Int
    
    @State private var isFavorite: Bool = false

    @EnvironmentObject var userViewModel: UserViewModel
    @ObservedObject var plantDetailsViewModel: PlantDetailsViewModel


    var body: some View {
        VStack {
            ZStack {
               
                AsyncImage(
                    url: URL(string: plantDetailsViewModel.plantDetails?.defaultImage?.thumbnail ?? "")
                ) { image in
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: .infinity, height: 280)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .shadow(color: .black.opacity(0.2), radius: 0.5, x:3, y: 3)
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
                    isFavorite.toggle()
                    Task {
                            if let plantDetails = plantDetailsViewModel.plantDetails {
                                let firePlant = FirePlant(from: plantDetails) // Umwandlung in FirePlant
                                await userViewModel.addPlantToFavorites(plant: firePlant)
                            } else {
                                print("Fehler: Pflanzendetails nicht geladen!")
                            }
                        }
                    
                } label: {
                    Image(systemName: isFavorite ? "heart.fill" : "heart")
                        .font(.system(size: 30))
                        .foregroundStyle(isFavorite ? .green : .white)
                        .padding()
                        .background(.black.opacity(0.2))
                        .clipShape(.circle)
                }
                .padding(.leading, 300)
                .padding(.bottom, 220)
            }
            Text("Common Name: \(plantDetailsViewModel.plantDetails?.commonName ?? "")")
            Text("Scientific Name: \(plantDetailsViewModel.plantDetails?.scientificName ?? [""])")
        

            List {
                Section("info") {
                    Text("Description: \(plantDetailsViewModel.plantDetails?.description ?? "")")
                    Text("Family: \(plantDetailsViewModel.plantDetails?.family ?? "")")
                    Text("Genus: \(plantDetailsViewModel.plantDetails?.genus ?? "")")
                    Text("Type: \(plantDetailsViewModel.plantDetails?.type ?? "")")
                    Text("Cycle: \(plantDetailsViewModel.plantDetails?.cycle ?? "")")
                    
                    Text("Attracts: \(plantDetailsViewModel.plantDetails?.attracts ?? [""])")

                }
                
                Section("Care") {
                    Text("Care Level: \(plantDetailsViewModel.plantDetails?.careLevel ?? "")")
                    Text("Watering: \(plantDetailsViewModel.plantDetails?.watering ?? "")")
                    HStack {
                        Text("WateringBenchmark: \(plantDetailsViewModel.plantDetails?.wateringBenchmark?.unit ?? "") |")
                        Text("WateringBenchmark: \(plantDetailsViewModel.plantDetails?.wateringBenchmark?.value ?? "")")
                    }
                    Text("Sunlight: \(plantDetailsViewModel.plantDetails?.sunlight ?? [""])")
                    Text("Indoor: \(plantDetailsViewModel.plantDetails?.indoor ?? true)")
                    Text("Cuisine: \(plantDetailsViewModel.plantDetails?.cuisine ?? false)")
                    Text("poisonousToHumans: \(plantDetailsViewModel.plantDetails?.poisonousToHumans ?? true)")
                    Text("poisonousToPets: \(plantDetailsViewModel.plantDetails?.poisonousToHumans ?? true)")
                    Text("soil: \(plantDetailsViewModel.plantDetails?.soil ?? [""])")
                    Text("origin: \(plantDetailsViewModel.plantDetails?.origin ?? [""])")
                    Text("pruningMonth: \(plantDetailsViewModel.plantDetails?.pruningMonth ?? [""])")
                    Text("invasive: \(plantDetailsViewModel.plantDetails?.invasive ?? true)")
                    Text("fruits: \(plantDetailsViewModel.plantDetails?.fruits ?? false)")
                    Text("edibleFruit: \(plantDetailsViewModel.plantDetails?.edibleFruit ?? false)")
                    Text("harvestSeason: \(plantDetailsViewModel.plantDetails?.harvestSeason ?? [""])")
                    Text("leaf: \(plantDetailsViewModel.plantDetails?.leaf ?? false)")
                    Text("edibleLeaf: \(plantDetailsViewModel.plantDetails?.edibleLeaf ?? false)")
//                    Text("hardiness: \(plantDetailsViewModel.plantDetails?.hardiness.min ?? 0)")
//                    Text("hardiness: \(plantDetailsViewModel.plantDetails?.hardiness.max ?? 0)")

                }
            }
        }
        .onAppear {
            plantDetailsViewModel.fetchPlantByID(selectedPlantId)
        }
    }
}

#Preview {
    PlantDetailView(selectedPlantId: 1, plantDetailsViewModel: PlantDetailsViewModel(plantId: 1))
}

