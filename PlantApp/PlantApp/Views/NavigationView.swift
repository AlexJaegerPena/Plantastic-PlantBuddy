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
    
    @EnvironmentObject var userViewModel: UserViewModel

    
    var body: some View {
        TabView {
            Tab("My Garden", systemImage: "skull") {
                HomeView()
                    .environmentObject(userViewModel)
            }
           
            Tab("Explore", systemImage: "magnifyingglass") {
                PlantSearchView(plantViewModel: PlantListViewModel())
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
        .environmentObject(UserViewModel())
}
