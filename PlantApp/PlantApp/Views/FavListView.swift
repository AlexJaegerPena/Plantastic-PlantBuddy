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
    @State private var showCalendar = false

    @State private var selectedCategory: UserCategory = .all

    var plantsByCategory: [FirePlant] {
        if selectedCategory == .all {
            return favPlantViewModel.favPlantsList
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
                    Button {

                    } label: {
                        HStack {
                            Image(systemName: "calendar")
                            Text("Calendar")
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .background(.cyan.opacity(0.4))
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                    }
                    .navigationDestination(isPresented: $showCalendar) {
//                        CalendarView()
                    }

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
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(.cyan.opacity(0.4))
                    .clipShape(RoundedRectangle(cornerRadius: 15))

                    //                    .shadow(color: .green, radius: 1)
                }
                .padding(.horizontal, 20)

                List(plantsByCategory) { plant in
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

                        .frame(width: 350, height: 100)
                        .padding()
                        .background(.white)
                        .listRowSeparator(.hidden)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .shadow(
                            color: .black.opacity(0.2), radius: 3, x: 3, y: 3
                        )

                        .alert("Are you sure?", isPresented: $showDeleteAlert) {
                            Button("Delete", role: .destructive) {
                                Task {
                                    do {
                                        await favPlantViewModel
                                            .removeFromFavorites(
                                                plantId: selectedPlantId)
                                    }
                                }
                            }
                        } message: {
                            Text("This plant will be removed from your garden.")
                        }
                }
                .listStyle(.plain)
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
