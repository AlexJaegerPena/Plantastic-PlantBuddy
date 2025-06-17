//
//  FavDetailView.swift
//  PlantApp
//
//  Created by Alexandra Jäger on 17.06.25.
//

import SwiftUI

struct FavDetailView: View {
    
    let selectedPlantId: String
    
    @EnvironmentObject var favPlantViewModel: FavPlantViewModel
    
    var body: some View {
        Text(selectedPlantId)
    }
}

#Preview {
    FavDetailView(selectedPlantId: "1")
        .environmentObject(FavPlantViewModel())
}
