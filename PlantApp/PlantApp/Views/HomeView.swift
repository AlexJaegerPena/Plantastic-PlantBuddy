//
//  HomeView.swift
//  PlantApp
//
//  Created by Alexandra Jäger on 26.05.25.
//

import SwiftUI

struct HomeView: View {
    
    @StateObject var weatherViewModel = WeatherViewModel()
    
    @EnvironmentObject var userViewModel: UserViewModel
    
    @State private var showProfile = false
    @State private var showSearch = false

    
    var body: some View {
        NavigationStack {
            VStack {
                WeatherView(weatherViewModel: weatherViewModel)
             Text("My Garden")
                Spacer()
                if userViewModel.favoritePlantsList.isEmpty {
                    Text("No plants added yet")
                } else {
                    List(userViewModel.favoritePlantsList, id: \.id) { plant in
                       
                        FavPlantListItemView(plant: plant)
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        showProfile = true
                    } label: {
                        HStack {
                            Image(systemName: "person")
                            Text("Hey, \(userViewModel.email.isEmpty ? "You" : userViewModel.email)!")
                                .font(.title3)
                        }
                    }
                    .navigationDestination(isPresented: $showProfile) {
                        SettingsView()
                            .environmentObject(userViewModel)
                    }
                    .tint(.black)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showSearch = true
                    } label: {
                        Image(systemName: "plus")
                    }
                    .tint(.black)
                    .navigationDestination(isPresented: $showSearch) {
                        PlantSearchView()
                    }
                }
            }
        }
        .onAppear {
            userViewModel.fetchFavoritePlants()
        }
    }
}

#Preview {
    HomeView()
        .environmentObject(WeatherViewModel())
        .environmentObject(UserViewModel())
}
