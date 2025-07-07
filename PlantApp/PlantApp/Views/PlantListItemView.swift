//
//  PlantListItemView.swift
//  PlantApp
//
//  Created by Alexandra Jäger on 05.06.25.
//

import SwiftUI
import Foundation


struct PlantListItemView: View {
    
    @EnvironmentObject var plantListViewModel: PlantListViewModel
    @EnvironmentObject var favPlantViewModel: FavPlantViewModel

    let plant: Plant
    
    private var countPlantType: Int {
        favPlantViewModel.favPlantsList.filter { $0.commonName == plant.commonName }.count
    }


    var body: some View {

            HStack {
                AsyncImage(
                    url: URL(string: plant.defaultImage?.thumbnail ?? "")
                ) { image in
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(minWidth: 100, maxWidth: 100, minHeight: 100, maxHeight: 100)
                        .clipShape(RoundedRectangle(cornerRadius: 18))
                        .shadow(color: .black.opacity(0.2), radius: 2, x:3, y: 3)
                } placeholder: {
                    Image("placeholderPlant")
                        .resizable()
                        .scaledToFit()
                        .frame(minWidth: 100, maxWidth: 100, minHeight: 100, maxHeight: 100)
                        .clipShape(RoundedRectangle(cornerRadius: 18))
                        .foregroundColor(Color("textColor"))
                }
                VStack(alignment: .leading, spacing: 5) {
                    Text(plant.commonName.lowercased().trimmingCharacters(in: .whitespacesAndNewlines).capitalized)
                        .font(.system(size: 18))
                        .fontWeight(.semibold)
                        .foregroundColor(Color("textColor"))

                    Text(plant.scientificName.first ?? "")
                        .font(.system(size: 14))
                        .foregroundStyle(.gray)
                        .padding(.bottom, 3)
                        .foregroundColor(Color("lightGrayColor"))
                    if countPlantType > 0 {
                        Text("\(countPlantType) in your garden")
                            .font(.system(size: 14))
                            .padding(.vertical, 4)
                            .padding(.horizontal, 10)
                            .foregroundStyle(.white)
                            .background(Color("secondaryPetrol"))
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
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
    .environmentObject(PlantListViewModel())
    .environmentObject(FavPlantViewModel())
}
