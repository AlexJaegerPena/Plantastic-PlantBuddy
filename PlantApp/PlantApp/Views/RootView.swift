//
//  RootView.swift
//  PlantApp
//
//  Created by Alexandra Jäger on 17.06.25.
//

import SwiftUI

// RootView um den Zustand von UserViewModel zu überwachen
struct RootView: View {

    @EnvironmentObject var userViewModel: UserViewModel
    @StateObject private var favPlantViewModel = FavPlantViewModel()
    @StateObject private var weatherViewModel = WeatherViewModel()

    var body: some View {
        Group {
            if userViewModel.isRegistrationComplete {
                NavView()
                    .environmentObject(favPlantViewModel)
                    .environmentObject(weatherViewModel)
            } else {
                WelcomeView()
            }
        }
    }
}

#Preview {
    RootView()
        .environmentObject(UserViewModel())
}
