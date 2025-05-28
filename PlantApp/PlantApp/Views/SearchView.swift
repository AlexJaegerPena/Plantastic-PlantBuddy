//
//  SearchView.swift
//  PlantApp
//
//  Created by Alexandra Jäger on 26.05.25.
//

import SwiftUI

struct SearchView: View {
    
    @ObservedObject var plantViewModel: PlantViewModel
    

    
    var body: some View {
        Text("Test")
        
        TextField("Search", text: $plantViewModel.searchTerm)
//        Button {
//            plantViewModel.getPlantByName()
//        } label: {
//            Image(systemName: "magnifyingglass")
//        }
//        .buttonStyle(.borderedProminent)
        
        Button {
            plantViewModel.apiPlantsList()
        } label: {
            Image(systemName: "magnifyingglass")
        }
        .buttonStyle(.borderedProminent)
        
        List(plantViewModel.plants) { plant in
            HStack {
                AsyncImage(url: URL(string: plant.defaultImage?.smallUrl ?? "placeholder"))
                { image in
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                } placeholder: {
                    ProgressView()
                }
                Text(plant.commonName ?? "")
            }
        }
    }
}
    
#Preview {
    SearchView(plantViewModel: PlantViewModel(plantRepository: RemotePlantRepository()))
}
