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
    @StateObject var settingsViewModel = SettingsViewModel()
    
    @EnvironmentObject var userViewModel: UserViewModel
    @EnvironmentObject var notificationsViewModel: NotificationsViewModel
    
    @State private var showProfile = false
    @State private var showSearch = false

    
    var body: some View {
        NavigationStack {
            VStack {
                WeatherView(weatherViewModel: weatherViewModel)
                Spacer()
                if favPlantViewModel.favPlantsList.isEmpty {
                    Text("No plants added yet :(")
                    Spacer()
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
                            .environmentObject(settingsViewModel)
                    }
//                    .tint(.black)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showSearch = true
                    } label: {
                        Image(systemName: "plus")
                    }
//                    .tint(.black)
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
    
    let mockUserViewModel = UserViewModel(
        mockUserId: "mockUser123",
        mockUsername: "Testuser",
        mockEmail: "test@plantapp.com"
    )
    
    HomeView()
        .environmentObject(WeatherViewModel())
        .environmentObject(mockUserViewModel)
        .environmentObject(UserViewModel())
        .environmentObject(FavPlantViewModel())
        .environmentObject(NotificationsViewModel())
        .environmentObject(SettingsViewModel())
}
