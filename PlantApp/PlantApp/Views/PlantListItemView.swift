//
//  PlantListItemView.swift
//  PlantApp
//
//  Created by Alexandra Jäger on 05.06.25.
//

import SwiftUI
import Foundation


struct PlantListItemView: View {
    
//    @ObservedObject var plantViewModel: PlantListViewModel
//    @ObservedObject var plantDetailsViewModel: PlantDetailsViewModel
    
    let plant: Plant

    
    var body: some View {

            HStack {
                AsyncImage(
                    url: URL(string: plant.defaultImage?.thumbnail ?? "")
                ) { image in
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .shadow(color: .black.opacity(0.2), radius: 2, x:3, y: 3)
                } placeholder: {
                    Image("placeholderPlant")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .foregroundColor(.gray)
                }
                VStack(alignment: .leading, spacing: 5) {
                    Text(plant.commonName)
                        .font(.system(size: 18))
                        .fontWeight(.semibold)

                    Text(plant.scientificName.first ?? "")
                        .font(.system(size: 14))
                        .foregroundStyle(.gray)
                        .padding(.bottom, 3)
                    Text(plant.family ?? "")
                        .font(.system(size: 14))
                        .padding(.vertical, 4)
                        .padding(.horizontal, 10)
                        .foregroundStyle(.white)
                        .background((plant.family != nil) ? .cyan.opacity(0.8) : .cyan.opacity(0))
                        .clipShape(RoundedRectangle(cornerRadius: 20))

                }
                .padding(.leading, 10)
                Spacer()
            }
    }
}

#Preview {
    PlantListItemView(plant: Plant(
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
