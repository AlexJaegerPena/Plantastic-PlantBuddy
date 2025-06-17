//
//  NavView.swift
//  PlantApp
//
//  Created by Alexandra Jäger on 26.05.25.
//

import SwiftUI

struct NavView: View {

    @State private var weatherViewModel = WeatherViewModel()
    @State private var hasAppeared = false
    
    @StateObject private var notificationsViewModel = NotificationsViewModel()
    @StateObject private var favPlantViewModel = FavPlantViewModel()
    
    @EnvironmentObject var userViewModel: UserViewModel

    
    var body: some View {
        TabView {
            Tab("Garden", systemImage: "leaf.fill") {
                    HomeView()
                        .environmentObject(userViewModel)
                        .environmentObject(favPlantViewModel)
            }
           
            Tab("Explore", systemImage: "magnifyingglass") {
                PlantSearchView(plantViewModel: PlantListViewModel())
                    .environmentObject(favPlantViewModel)
            }
            Tab("Calendar", systemImage: "calendar") {
                CalendarView()
            }
        }
        .onAppear {
            if !hasAppeared {
                notificationsViewModel.requestPermission()
                hasAppeared = true
            }
        }
    }
}

#Preview {
    NavView()
        .environmentObject(UserViewModel())
}
