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
            Tab("Home", systemImage: "house") {
                HomeView()
                    .environmentObject(loginViewModel)
            }
           
            Tab("Add", systemImage: "plus") {
                PlantSearchView(plantViewModel: PlantViewModel(plantRepository: RemotePlantRepository()))
            }
            Tab("Calendar", systemImage: "calendar") {
                
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
