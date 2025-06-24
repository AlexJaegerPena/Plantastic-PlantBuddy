//
//  WateringIndicatorView.swift
//  PlantApp
//
//  Created by Alexandra Jäger on 16.06.25.
//

import SwiftUI

struct WateringIndicatorView: View {

    let watering: Watering

    var body: some View {
        HStack {
            if watering.rawValue == "none" {
                Image(systemName: watering.icon)
                    .foregroundStyle(.gray)
            } else {
                ForEach(0..<watering.dropCount, id: \.self) { _ in
                    Image(systemName: watering.icon)
                        .foregroundStyle(.cyan)
                }
            }
        }
    }
}

#Preview {
    WateringIndicatorView(watering: Watering(rawValue: "frequent")!)
}
