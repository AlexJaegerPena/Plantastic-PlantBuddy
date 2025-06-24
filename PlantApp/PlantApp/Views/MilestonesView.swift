//
//  MilestonesView.swift
//  PlantApp
//
//  Created by Alexandra Jäger on 26.05.25.
//

import SwiftUI

struct MilestonesView: View {
    
    @State private var wateringProgressTotal = 3.0
    @State private var wateringProgressOnePlant = 4.0
    @State private var gardenSize = 6.0
    
    private let min = 0.0
    private let max = 100.0
    
    var body: some View {
        VStack {
            Text("Milestones")
                .padding()
            Gauge(value: wateringProgressTotal, in: min...max) {
                Text("Watered plants in total")
            } currentValueLabel: {
                Text(wateringProgressTotal.description)
            } minimumValueLabel: {
                Text(min.description)
            } maximumValueLabel: {
                Text(max.description)
            }
            .padding()
            .background(.cyan.opacity(0.6))
            .clipShape(RoundedRectangle(cornerRadius: 20))

            
            Gauge(value: wateringProgressOnePlant, in: min...max) {
                Text("Watered plants in total")
            } currentValueLabel: {
                Text(wateringProgressOnePlant.description)
            } minimumValueLabel: {
                Text(min.description)
            } maximumValueLabel: {
                Text(max.description)
            }
            .padding()
            .background(.cyan.opacity(0.6))
            .clipShape(RoundedRectangle(cornerRadius: 20))

            
            Gauge(value: gardenSize, in: min...max) {
                Text("Watered plants in total")
            } currentValueLabel: {
                Text(gardenSize.description)
            } minimumValueLabel: {
                Text(min.description)
            } maximumValueLabel: {
                Text(max.description)
            }
            .padding()
            .background(.cyan.opacity(0.6))
            .clipShape(RoundedRectangle(cornerRadius: 20))

        }
        .padding()
    }
}

#Preview {
    MilestonesView()
}
