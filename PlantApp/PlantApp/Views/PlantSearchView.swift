//
//  SearchView.swift
//  PlantApp
//
//  Created by Alexandra Jäger on 26.05.25.
//

import SwiftUI

struct PlantSearchView: View {
    
    @ObservedObject var plantViewModel: PlantViewModel
    
//    @State private var searchQuery: String = ""
//    @State private var plantResults: [PlantResponse]
    
    var body: some View {
        NavigationStack {
            
            TextField("Search", text: $plantViewModel.searchTerm)
                .onChange(of: plantViewModel.searchTerm) {
                    plantViewModel.searchPlantByName(for: plantViewModel.searchTerm)
                }

            
            Button {
                plantViewModel.searchPlantByName(for: plantViewModel.searchTerm)
            } label: {
                Image(systemName: "magnifyingglass")
            }
            .buttonStyle(.borderedProminent)
            
            List(plantViewModel.plants) { plant in
                HStack {
                    AsyncImage(url: URL(string: plant.defaultImage?.thumbnail ?? "placeholderPlant"))
                    { image in
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    } placeholder: {
                        ProgressView()
                    }
                    VStack(alignment: .leading) {
                        Text(plant.commonName ?? "")
                        Text(plant.scientificName?.first ?? "")
                            .foregroundStyle(.gray)
                        Text("ID: \(plant.id)")
                    }

                }
            }
            .navigationTitle("Search for a Plant")
        }
        .onAppear {
            plantViewModel.apiPlantsList()
        }
    }
}
    
#Preview {
    PlantSearchView(plantViewModel: PlantViewModel(plantRepository: RemotePlantRepository()))
}
