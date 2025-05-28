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
    
    var body: some View {
        TabView {
            Tab("Home", systemImage: "house") {
                HomeView()
            }
           
            Tab("Add", systemImage: "plus") {
                SearchView(plantViewModel: PlantViewModel(plantRepository: RemotePlantRepository()))
            }
            Tab("Calendar", systemImage: "calendar") {
                
            }
            Tab("Profile", systemImage: "person") {
                ProfileView()
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
}
