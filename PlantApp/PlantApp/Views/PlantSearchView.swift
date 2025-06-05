//
//  PlantSearchView.swift
//  PlantApp
//
//  Created by Alexandra Jäger on 26.05.25.
//

import SwiftUI

struct PlantSearchView: View {

    @StateObject var plantViewModel = PlantListViewModel(
        plantRepository: RemotePlantRepository())

    @State private var selectedPlantId: Int = 0

    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    TextField("Search", text: $plantViewModel.searchTerm)
                        .padding(8)
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                        .onChange(of: plantViewModel.searchTerm) { oldValue, newValue in
                            plantViewModel.plantSuggestions(for: newValue)
                        }

                    Button {
                        plantViewModel.searchPlantByName(for: plantViewModel.searchTerm)
                    } label: {
                        Image(systemName: "magnifyingglass")
                    }
                    .buttonStyle(.borderedProminent)
                }
                .padding(.horizontal)

                if !plantViewModel.searchTerm.isEmpty {
                    List(plantViewModel.plantSuggestionList) { plant in
                        NavigationLink(
                            destination: PlantDetailView(selectedPlantId: plant.id)
                        ) {
                            Text(plant.commonName)
                        }
                    }
                    .listStyle(.plain)
                } else {
                    List(plantViewModel.plants) { plant in
                        NavigationLink(
                            destination: PlantDetailView(selectedPlantId: plant.id)
                        ) {
                            HStack {
                                AsyncImage(
                                    url: URL(string: plant.defaultImage?.thumbnail ?? "")
                                ) { image in
                                    image
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 100, height: 100)
                                        .clipShape(RoundedRectangle(cornerRadius: 12))
                                        .shadow(color: .black.opacity(0.2), radius: 0.5, x:3, y: 3)
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
                                }
                                .padding(.leading, 10)
                            }
                        }
                    }
                   .listStyle(.plain)
                }
            }
        }
        .onAppear {
            plantViewModel.apiPlantsList()
        }
    }
}

// Preview Provider
#Preview {
    PlantSearchView(
        plantViewModel: PlantListViewModel(plantRepository: LocalPlantRepository())
    )
}

