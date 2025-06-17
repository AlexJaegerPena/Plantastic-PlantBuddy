//
//  FavListView.swift
//  PlantApp
//
//  Created by Alexandra Jäger on 17.06.25.
//

import SwiftUI

struct FavListView: View {
    
    @EnvironmentObject var favPlantViewModel: FavPlantViewModel

    @State private var selectedPlantId: Int = 0
    @State private var animatingCard: Int? = nil
    @State private var navigateToDetail = false
    
    
    var body: some View {
        NavigationStack {
            VStack {
                List(favPlantViewModel.favPlantsList) { plant in
                    
                    VStack {
                        FavListItemView(plant: plant)
                        
                            .background(
                                NavigationLink(
                                    "",
                                    destination: FavDetailView(selectedPlantId: plant.id ?? "0")
                                )
                                .opacity(0)
                            )
                    }
                    
                    .frame(width: 350, height: 100)
                    .padding()
                    .background(.white)
                    .listRowSeparator(.hidden)
                    
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .shadow(color: .black.opacity(0.2), radius: 3, x: 3, y: 3)
                    
                }
                .listStyle(.plain)
            }
        }
        .onAppear {
            Task {
                do {
                   await favPlantViewModel.loadFavorites()
                }
                
            }
           
        }
    }
}

#Preview {
    FavListView()
        .environmentObject(FavPlantViewModel())
}
