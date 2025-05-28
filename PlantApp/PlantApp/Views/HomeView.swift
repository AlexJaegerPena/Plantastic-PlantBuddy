//
//  HomeView.swift
//  PlantApp
//
//  Created by Alexandra Jäger on 26.05.25.
//

import SwiftUI

struct HomeView: View {
    
    @StateObject var weatherViewModel = WeatherViewModel()
    @StateObject private var plantViewModel = PlantViewModel(plantRepository: RemotePlantRepository())
    
    
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
                            Text("Hey, Name!")
                                .font(.title3)
                        }
                    }
                    .navigationDestination(isPresented: $showProfile) {
                        ProfileView()
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
}
