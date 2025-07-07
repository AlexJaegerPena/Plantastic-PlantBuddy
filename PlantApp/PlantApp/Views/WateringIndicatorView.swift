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
        HStack(spacing: 0) {
            if watering.rawValue == "none" {
                Text(watering.icon)
            } else {
                ForEach(0..<watering.dropCount, id: \.self) { _ in
                    Text(watering.icon)
                        .padding(0)
                }
            }
        }
    }
}

#Preview {
    WateringIndicatorView(watering: Watering(rawValue: "frequent")!)
}
