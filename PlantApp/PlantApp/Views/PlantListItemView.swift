//
//  PlantListItemView.swift
//  PlantApp
//
//  Created by Alexandra Jäger on 05.06.25.
//

import SwiftUI
import Foundation


struct PlantListItemView: View {
    
    @ObservedObject var plantViewModel: PlantListViewModel
    @State var plant: Plant

    
    var body: some View {
        HStack {
            AsyncImage(
                url: URL(
                    string: plant.defaultImage?.thumbnail ?? ""
                        )
            ) { image in
                image
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .clipShape(
                        RoundedRectangle(cornerRadius: 12))
            } placeholder: {
                Image("placeholderPlant")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .foregroundColor(.gray)                                }
            VStack(alignment: .leading) {
                Text(plant.commonName)
                Text(plant.scientificName.first ?? "")
                    .foregroundStyle(.gray)
                Text("ID: \(plant.id)")
            }
        }
    }
}

#Preview {
    PlantListItemView(plantViewModel: PlantListViewModel(plantRepository: RemotePlantRepository()), plant: Plant(
        id: 3,
        commonName: "Fiddle Leaf Fig",
        scientificName: ["Ficus lyrata"],
        otherName: ["Ficus lyrata"],
        family: "Moraceae",
        genus: "Ficus",
        defaultImage: PlantImages(
            originalUrl: "https://example.com/fiddle_leaf_fig.jpg",
            regularUrl: "https://example.com/fiddle_leaf_fig_regular.jpg",
            mediumUrl: "https://example.com/fiddle_leaf_fig_medium.jpg",
            smallUrl: "https://example.com/fiddle_leaf_fig_small.jpg",
            thumbnail: "https://example.com/fiddle_leaf_fig_thumbnail.jpg"
        )
    ))
}
