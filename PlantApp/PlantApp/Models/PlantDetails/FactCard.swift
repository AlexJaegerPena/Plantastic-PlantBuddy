//
//  FactCard.swift
//  PlantApp
//
//  Created by Alexandra Jäger on 30.06.25.
//

import SwiftUI

struct FactCard: View {
    let icon: String
    let title: String
    let value: String


    var body: some View {
        VStack(spacing: 8) {
            Text(icon)
                .font(.title2)
            Text(title)
                .font(.caption)
                .fontWeight(.light)
                .foregroundStyle(Color("textColor"))
                .multilineTextAlignment(.center)
            Text(value)
                .font(.body)
                .fontWeight(.medium)
                .foregroundStyle(Color("textColor"))
                .multilineTextAlignment(.center)
        }
        .padding(12)
        .frame(maxWidth: .infinity, minHeight: 130)
//        .background(.white)
        .background(Color("cardBg"))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
//                .stroke(tintColor.opacity(0.5), lineWidth: 1)
                .stroke(Color("secondaryPetrol").opacity(0.5), lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.1), radius: 3, x: 0, y: 2)
    }
}

#Preview {
    FactCard(icon: "💧", title: "Test", value: "medium")
}
