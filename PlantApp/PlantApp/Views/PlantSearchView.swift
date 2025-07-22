//
//  PlantSearchView.swift
//  PlantApp
//
//  Created by Alexandra Jäger on 26.05.25.
//

import SwiftUI

struct PlantSearchView: View {

    @StateObject var plantListViewModel = PlantListViewModel()

    @EnvironmentObject var favPlantViewModel: FavPlantViewModel

    @State private var selectedPlantId: Int = 0
    //    @State private var animatingCard: Int? = nil
    @State private var navigateToDetail = false
    @State private var showEmptyResult = false

    private var displayedPlants: [Plant] {
        if plantListViewModel.searchTerm.isEmpty {
            return plantListViewModel.plants
        } else {
            return plantListViewModel.plantSuggestionList
        }
    }

    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    HStack {
                        TextField(
                            "Search", text: $plantListViewModel.searchTerm
                        )
                        .padding(8)
                        .onChange(of: plantListViewModel.searchTerm) {
                            oldValue, newValue in
                            plantListViewModel.plantSuggestions(for: newValue)
                            showEmptyResult = false
                            // zeitverzögerung für EmptySearchResultView()
                            DispatchQueue.main.asyncAfter(
                                deadline: .now() + 1.5
                            ) {
                                if plantListViewModel.searchTerm == newValue
                                    && displayedPlants.isEmpty
                                {
                                    showEmptyResult = true
                                }
                            }
                        }
                        Button {
                            plantListViewModel.searchTerm = ""
                        } label: {
                            Image(systemName: "xmark.circle")
                        }
                        .tint(Color("myLightGrayColor"))
                        .padding(.trailing, 10)
                    }
                    .background(Color("bgColor"))
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color("primaryPetrol"), lineWidth: 1)
                    )
                }
                .padding(.horizontal)

                if showEmptyResult {
                    EmptySearchResultView()
                } else {
                    List(displayedPlants) { plant in
                        let detailViewModel = PlantDetailsViewModel(
                            plantId: plant.id)
                        VStack {
                            PlantListItemView(plant: plant)
                                .environmentObject(plantListViewModel)
                                .environmentObject(favPlantViewModel)
                                .background(
                                    NavigationLink(
                                        "",
                                        destination: PlantDetailView(
                                            selectedPlant: plant,
                                            selectedPlantId: plant.id)
                                    )
                                    .opacity(0)
                                )
                        }
                        .frame(width: .infinity, height: 100)
                        .padding(.horizontal, 7)
                        .padding(.vertical, 7)
                        .background(Color("cardBg"))
                        .listRowSeparator(.hidden)
                        .listRowInsets(
                            EdgeInsets(
                                top: 5, leading: 10, bottom: 5, trailing: 10)
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .shadow(
                            color: .black.opacity(0.2), radius: 3, x: 3, y: 3)
                    }
                    .listStyle(.plain)
                }
            }
        }
        .navigationTitle("Add plants to your Garden")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct EmptySearchResultView: View {
    var body: some View {
        VStack(spacing: 10) {
            Image("noPlantFound")
                .resizable()
                .scaledToFit()
                .frame(width: 120)
                .opacity(0.7)
            Text("No matching plants found.")
                .foregroundColor(Color("myLightGrayColor"))
            Spacer()
        }
        .padding(.top, 200)
    }
}

// Preview Provider
#Preview {
    PlantSearchView(
        plantListViewModel: PlantListViewModel()
    )
    .environmentObject(PlantListViewModel())
    .environmentObject(FavPlantViewModel())
}
