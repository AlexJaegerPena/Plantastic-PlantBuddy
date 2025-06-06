//
//  NavigationView.swift
//  PlantApp
//
//  Created by Alexandra Jäger on 26.05.25.
//

import SwiftUI

struct NavigationView: View {

    @State private var weatherViewModel = WeatherViewModel()
    @State private var hasAppeared = false
    
    @StateObject private var notificationsViewModel = NotificationsViewModel()
    
    @EnvironmentObject var loginViewModel: LoginViewModel

    
    var body: some View {
        TabView {
            Tab("Home", systemImage: "leaf.fill") {
                HomeView()
                    .environmentObject(loginViewModel)
            }
           
            Tab("Search", systemImage: "magnifyingglass") {
                PlantSearchView(plantViewModel: PlantListViewModel(plantRepository: LocalPlantRepository()))
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
    NavigationView()
        .environmentObject(LoginViewModel())
}
