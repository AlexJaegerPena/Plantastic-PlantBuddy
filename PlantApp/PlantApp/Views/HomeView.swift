//
//  HomeView.swift
//  PlantApp
//
//  Created by Alexandra Jäger on 26.05.25.
//

import SwiftUI

struct HomeView: View {
    
    @StateObject var weatherViewModel = WeatherViewModel()
    
    @EnvironmentObject var loginViewModel: LoginViewModel
    
    @State private var showProfile = false
    
    var body: some View {
        NavigationStack {
            VStack {
                
                WeatherView(weatherViewModel: weatherViewModel)
             Text("home")
                Spacer()
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        showProfile = true
                    } label: {
                        HStack {
                            Image(systemName: "person")
                            Text("Hey, \(loginViewModel.username ?? "You")!")
                                .font(.title3)
                        }
                    }
                    .navigationDestination(isPresented: $showProfile) {
                        SettingsView()
                            .environmentObject(loginViewModel)
                    }
                    .tint(.black)
                }
            }
        }
    }
}

#Preview {
    HomeView()
        .environmentObject(WeatherViewModel())
        .environmentObject(LoginViewModel())
}
