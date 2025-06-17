//
//  HomeView.swift
//  PlantApp
//
//  Created by Alexandra Jäger on 26.05.25.
//

import SwiftUI

struct HomeView: View {
    
    @StateObject var weatherViewModel = WeatherViewModel()
    @StateObject var favPlantViewModel = FavPlantViewModel()
    
    @EnvironmentObject var userViewModel: UserViewModel
    
    @State private var showProfile = false
    @State private var showSearch = false

    
    var body: some View {
        NavigationStack {
            VStack {
                WeatherView(weatherViewModel: weatherViewModel)
             Text("My Garden")
                Spacer()
                if favPlantViewModel.favPlantsList.isEmpty {
                    Text("No plants added yet")
                } else {
                    FavListView()
                
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        showProfile = true
                    } label: {
                        HStack {
                            Image(systemName: "person")
                            Text("Hey, \(userViewModel.username.isEmpty ? "You" : userViewModel.username)!")
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
            Task {
                await favPlantViewModel.loadFavorites()
    
            }
        }
    }
}

#Preview {
    HomeView()
        .environmentObject(WeatherViewModel())
        .environmentObject(UserViewModel())
        .environmentObject(FavPlantViewModel())
}
