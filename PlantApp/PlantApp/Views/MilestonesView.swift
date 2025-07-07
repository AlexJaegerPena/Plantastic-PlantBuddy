//
//  MilestonesView.swift
//  PlantApp
//
//  Created by Alexandra Jäger on 26.05.25.
//

import SwiftUI

struct MilestoneCard: View {
    let value: Double
    let title: String
    let currentValueLabel: Double
    let minValue: Double
    let maxValue: Double
    let stamp: String = "stamp"
    let icon: String
    //    let tintColor: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Gauge(value: value, in: minValue...maxValue) {
                HStack {
                    Image(icon)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 30)
                    Text(title)
                        .font(.title3)
                        .fontWeight(.regular)
                        .foregroundStyle(Color("textColor"))
                }
            } currentValueLabel: {
                currentValueLabel >= maxValue
                    ? Text("")
                    : Text(
                        "\(String(format: "%.f", currentValueLabel)) / \(String(format: "%.f", maxValue))"
                    )
                    .foregroundStyle(Color("textColor").opacity(0.6))
            }
            .tint(Color("secondaryPetrol"))
            .padding()
            .background(Color("cardBg"))
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color("secondaryPetrol").opacity(0.5), lineWidth: 2)
            )
            .overlay(
                Image(currentValueLabel >= maxValue ? stamp : "")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 80)
                    .padding(.bottom, 55)
                    .padding(.leading, 270)
                    .rotationEffect(.degrees(20), anchor: .center)
            )
        }
        .shadow(color: Color("secondaryPetrol").opacity(0.3), radius: 3, x: 1, y: 1)
        .frame(width: .infinity, height: 130, alignment: .leading)
        .padding(.horizontal,2)
        
        //        .shadow(color: .blue.opacity(0.3), radius: 3, x: 1, y: 1)
    }
}


struct MilestonesView: View {
    
    @EnvironmentObject var favPlantViewModel: FavPlantViewModel

    @State private var ownedPlantsCount: Double = 0.0
    @State private var wateringTotalCount: Double = 0.0
    @State private var wateringProgressOnePlant = 4.0
    @State private var gardenSize = 6.0

    private let min = 0.0


    var body: some View {
        ScrollView {
            Text("🏆 Milestones 🏆")
                .font(.title)
                .fontWeight(.semibold)
                .padding(.bottom, 30)
                .foregroundStyle(Color("primaryPetrol"))
            
            Text("Watering Milestones")
                .font(.title2)
                .fontWeight(.medium)
                .foregroundStyle(Color("secondaryPetrol"))

            MilestoneCard(
                value: wateringTotalCount,
                title: "Water 5 plants",
                currentValueLabel: wateringTotalCount, minValue: min,
                maxValue: 5, icon: "canPetrol")

            MilestoneCard(
                value: wateringTotalCount,
                title: "Water 10 plants",
                currentValueLabel: wateringTotalCount, minValue: min,
                maxValue: 10, icon: "canPetrol")

            MilestoneCard(
                value: wateringTotalCount,
                title: "Water 25 plants",
                currentValueLabel: wateringTotalCount, minValue: min,
                maxValue: 25, icon: "canPetrol")

            MilestoneCard(
                value: wateringTotalCount,
                title: "Water 50 plants",
                currentValueLabel: wateringTotalCount, minValue: min,
                maxValue: 50, icon: "canPetrol")
            
            Divider()
                .padding(.top, 30)
                .padding(.bottom, 10)
            
            Text("Garden Milestones")
                .font(.title2)
                .fontWeight(.medium)
                .foregroundStyle(Color("secondaryPetrol"))
            MilestoneCard(
                value: ownedPlantsCount,
                title: "Add 5 plants to your garden",
                currentValueLabel: ownedPlantsCount, minValue: min,
                maxValue: 5, icon: "plantMilestones")

            MilestoneCard(
                value: ownedPlantsCount,
                title: "Add 10 plants to your garden",
                currentValueLabel: ownedPlantsCount, minValue: min,
                maxValue: 10, icon: "plantMilestones")

            MilestoneCard(
                value: ownedPlantsCount,
                title: "Add 25 plants to your garden",
                currentValueLabel: ownedPlantsCount, minValue: min,
                maxValue: 25, icon: "plantMilestones")

            MilestoneCard(
                value: ownedPlantsCount,
                title: "Add 50 plants to your garden",
                currentValueLabel: ownedPlantsCount, minValue: min,
                maxValue: 50, icon: "plantMilestones")

        }
        .padding()
        .onAppear {
            self.wateringTotalCount = Double(favPlantViewModel.allWateringsCount)
            self.ownedPlantsCount = Double(favPlantViewModel.favPlantsList.count)
        }
        .onChange(of: favPlantViewModel.favPlantsList.count) { oldValue, newValue in
            self.ownedPlantsCount = Double(newValue)
        }
    }
}





#Preview {
    MilestonesView()
        .environmentObject(FavPlantViewModel())
}
