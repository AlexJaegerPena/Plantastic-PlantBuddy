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

    // isActive für zeitverzögerte Einblendung von NavView nach LoadingScreenView
    @State private var isActive = false

    var body: some View {
        Group {
            if userViewModel.isUsernameSet {
                if isActive {
                    NavView()
                        .transition(.opacity)
                        .animation(.easeInOut(duration: 0.5), value: isActive)
                        .environmentObject(favPlantViewModel)
                        .environmentObject(weatherViewModel)
                } else {
                    LoadingScreenView()
                        .environmentObject(userViewModel)
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 3.5) {
                                withAnimation {
                                    isActive = true
                                }
                            }
                        }
                }
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
