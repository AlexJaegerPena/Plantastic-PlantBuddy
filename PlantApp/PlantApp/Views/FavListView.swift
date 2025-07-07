//
//  FavListView.swift
//  PlantApp
//
//  Created by Alexandra Jäger on 17.06.25.
//

import SwiftUI

struct FavListView: View {

    @EnvironmentObject var favPlantViewModel: FavPlantViewModel

    @State private var selectedPlantId: String = ""
    @State private var animatingCard: Int? = nil
    @State private var navigateToDetail = false
    @State private var showAddSheet = false
    @State private var showOptionsAlert = false
    @State private var showDeleteAlert = false
    @State private var showDelSuccessAlert = false

    @State private var selectedCategory: UserCategory = .all

    var plantsByCategory: [FirePlant] {
        if selectedCategory == .all {
            
            // --- Fav Plants List Source ---
            // Firebase
            return favPlantViewModel.favPlantsList
            // Dummy
//            return favPlantViewModel.dummyFavPlants

        } else {
            return favPlantViewModel.favPlantsList.filter {
                $0.userCategory == selectedCategory
            }
        }
    }
    

    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Text("My Garden")
                        .font(.system(size: 26, weight: .light))
                        .foregroundStyle(Color("primaryPetrol"))
                    
                    Spacer()
                    Picker("Title", selection: $selectedCategory) {
                        ForEach(UserCategory.allCases) { category in
                            HStack {
                                Text(category.rawValue)
                                Image(systemName: category.icon)
                                    .padding(.trailing, 5)
                            }
                            .tag(category)
                        }
                    }
                    .tint(Color("primaryPetrol"))
                    .padding(.horizontal, 2)
                    .padding(.vertical, 1)
                    .background(Color("secondaryPetrol").opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color("secondaryPetrol").opacity(0.2), lineWidth: 2)
                    )
                }
                .padding(.horizontal, 20)
                
                List(plantsByCategory.sorted(by: {
                    // wenn $0 nil, dann $0 vor $1 - früher
                    guard let date0 = $0.nextWaterDate else { return true }
                    // wenn $1 nil, dann $1 vor $0 - früher
                    guard let date1 = $1.nextWaterDate else { return false }
                    return date0 < date1 })) { plant in
                    
                    FavListItemView(plant: plant)
                        .buttonStyle(.plain)

                        .swipeActions {
                            Button(
                                "Delete", systemImage: "trash",
                                role: .destructive
                            ) {
                                showDeleteAlert = true
                                selectedPlantId = plant.id ?? "0"
                            }
                        }

                        .padding(.horizontal, 5)
                        .padding(.vertical, 10)
                        .background(Color("cardBg"))
                        .listRowSeparator(.hidden)
                        .listRowInsets(EdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10))
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .shadow(color: .black.opacity(0.2), radius: 3, x: 3, y: 3)
                }
                .listStyle(.plain)
                
            }
            .alert("Delete this plant?", isPresented: $showDeleteAlert) {
                Button("Delete", role: .destructive) {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                        Task {
                            do {
                                await favPlantViewModel
                                    .removeFromFavorites(
                                        plantId: selectedPlantId)
                                showDelSuccessAlert = true
                            }
                        }
                    }
                }
            } message: {
                Text("Are you sure you want to remove this plant from your garden?")
            }
            .alert("Plant Removed",isPresented: $showDelSuccessAlert) {
                Button("Ok", role: .cancel) { }
            } message: {
                Text("The plant has been successfully removed from your garden.")
            }
        }

        .onAppear {
            Task {
                do {
                    await favPlantViewModel.loadFavorites()
                }
            }
        }
    }
}
#Preview {
    FavListView()
        .environmentObject(FavPlantViewModel())
}
