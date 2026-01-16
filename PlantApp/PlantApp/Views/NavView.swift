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
            Tab("My Garden", systemImage: "leaf.fill") {
                NavigationStack {
                    HomeView()
                        .environmentObject(userViewModel)
                        .environmentObject(favPlantViewModel)
                        .navigationTitle("My Garden")
                        .navigationBarTitleDisplayMode(.inline)
                }
            }
            Tab("Explore", systemImage: "magnifyingglass") {
                NavigationStack {
                    PlantSearchView(plantListViewModel: PlantListViewModel())
                        .environmentObject(favPlantViewModel)
                        .navigationTitle("Explore Plants")
                        .navigationBarTitleDisplayMode(.inline)
                        .toolbar(.visible, for: .navigationBar)
                        .toolbarBackground(.visible, for: .navigationBar)
                }
            }
            Tab("Calendar", systemImage: "calendar") {
                NavigationStack {
                    CalendarView()
                        .environmentObject(favPlantViewModel)
                        .navigationTitle("Watering Calendar")
                        .navigationBarTitleDisplayMode(.inline)
                        .toolbar(.visible, for: .navigationBar)
                        .toolbarBackground(.visible, for: .navigationBar)
                }
            }
        }
        .tint(Color("secondaryColor"))
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
