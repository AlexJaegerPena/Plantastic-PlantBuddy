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
                    Image("mascot")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 160, height: 160)
                        .padding(5)
                        .opacity(0.6)
                    Text("No plants in your garden yet.\n\nKlick 🔍 Explore and\nadd plants to your favorites.")
                        .foregroundStyle(Color("textColor"))
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
                        Image(systemName: "person.fill")
                    }
                    .navigationDestination(isPresented: $showProfile) {
                        SettingsView()
                            .environmentObject(userViewModel)
                            .environmentObject(settingsViewModel)
                    }
                    .tint(Color("textColor"))
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showMilestones = true
                    } label: {
                        Image(systemName: "trophy.fill")
                    }
                    .tint(Color("textColor"))
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
    HomeView()
        .environmentObject(WeatherViewModel())
        .environmentObject(UserViewModel())
        .environmentObject(FavPlantViewModel())
        .environmentObject(NotificationsViewModel())
        .environmentObject(SettingsViewModel())
}
