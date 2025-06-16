//
//  PlantSearchView.swift
//  PlantApp
//
//  Created by Alexandra Jäger on 26.05.25.
//

import SwiftUI

struct PlantSearchView: View {
    
    @StateObject var plantViewModel = PlantListViewModel()
    
    @State private var selectedPlantId: Int = 0
    @State private var animatingCard: Int? = nil
    @State private var navigateToDetail = false
    
    private var displayedPlants: [Plant] {
        if plantViewModel.searchTerm.isEmpty {
            return plantViewModel.plants
        } else {
            return plantViewModel.plantSuggestionList
        }
    }

    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    HStack {
                        TextField("Search", text: $plantViewModel.searchTerm)
                            .padding(8)
                            
                            .onChange(of: plantViewModel.searchTerm) { oldValue, newValue in
                                plantViewModel.plantSuggestions(for: newValue)
                            }
                        Button {
                                plantViewModel.searchTerm = ""
                            } label: {
                                Image(systemName: "xmark.circle")
                            }
                            .tint(.black.opacity(0.8))
                            .padding(.trailing, 10)
                    }
                    .background(Color(.systemGray6))
                    .cornerRadius(15)

                    Button {
                        plantViewModel.searchPlantByName(for: plantViewModel.searchTerm)
                    } label: {
                        Image(systemName: "magnifyingglass")
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.black.opacity(0.8))
                    .cornerRadius(12)
                }
                .padding(.horizontal)

            
                    List(displayedPlants) { plant in
                        let detailViewModel = PlantDetailsViewModel(plantId: plant.id)
                        VStack {
                            PlantListItemView(plant: plant)
                      
                            .background(
                                NavigationLink(
                                    "",
                                    destination: PlantDetailView(selectedPlantId: plant.id, plantDetailsViewModel: detailViewModel)
                                )
                                .opacity(0)
                            )
                        }
                    
                        .frame(width: 350, height: 100)
                        .padding()
                        .background(.white)
                        .listRowSeparator(.hidden)
                       
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .shadow(color: .black.opacity(0.2), radius: 3, x: 3, y: 3)

                    }
                    .listStyle(.plain)
            }
        }
        .onAppear {
            plantViewModel.apiPlantsList()
            plantViewModel.searchTerm = ""
        }
    }
}

// Preview Provider
#Preview {
    PlantSearchView(
        plantViewModel: PlantListViewModel()
    )
}

