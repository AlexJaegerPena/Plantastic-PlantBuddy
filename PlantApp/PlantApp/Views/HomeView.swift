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
    @State private var showMilestones = false
    
    var body: some View {
        NavigationStack {
            VStack {
                WeatherView(weatherViewModel: weatherViewModel)
                Spacer()
                
                if favPlantViewModel.favPlantsList.isEmpty {
                    Image("emptyGarden")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 160, height: 160)
                        .padding(.leading, 60)
                        .opacity(0.6)
                    Text("No plants in your garden yet.\n\nKlick 🔍 Explore and\nadd plants to your favorites.")
                        .foregroundStyle(Color("primaryPetrol"))
                        .multilineTextAlignment(.center)
                        .padding(.bottom, 50)
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
//                            Image(systemName: "person.crop.circle")
                            Image("userImage")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 35, height: 35)
                            Text("Hey, \(userViewModel.username.isEmpty ? "You" : userViewModel.username)!")
                                .font(.title3)
                        }
                    }
                    .navigationDestination(isPresented: $showProfile) {
                        SettingsView()
                            .environmentObject(userViewModel)
                            .environmentObject(settingsViewModel)
                    }
                    .tint(Color("primaryPetrol"))
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showMilestones = true
                    } label: {
                        Image(systemName: "trophy.fill")
                    }
                    .tint(Color("primaryPetrol"))
                    .navigationDestination(isPresented: $showMilestones) {
                        MilestonesView()
                            .environmentObject(favPlantViewModel)
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
    
//    let mockUserViewModel = UserViewModel(
//        mockUserId: "mockUser123",
//        mockUsername: "Testuser",
//        mockEmail: "test@plantapp.com"
//    )
    
    HomeView()
        .environmentObject(WeatherViewModel())
//        .environmentObject(mockUserViewModel)
        .environmentObject(UserViewModel())
        .environmentObject(FavPlantViewModel())
        .environmentObject(NotificationsViewModel())
        .environmentObject(SettingsViewModel())
}
