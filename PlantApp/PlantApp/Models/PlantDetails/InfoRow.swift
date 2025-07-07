//
//  InfoRowView.swift
//  PlantApp
//
//  Created by Alexandra Jäger on 30.06.25.
//

import SwiftUI

struct InfoRow: View {
    let icon: String?
    let title: String
    let value: String?
    
    var body: some View {
        HStack(alignment: .top) {
            if let icon = icon {
                Image(systemName: icon)
                    .font(.body)
                    .foregroundStyle(Color("secondaryPetrol"))
                    .frame(width: 25, alignment: .leading)
            }
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundStyle(Color("secondaryPetrol"))
                Text(value ?? "no information")
                    .font(.body)
                    .foregroundStyle(Color("textColor"))
                    .lineLimit(2)
            }
            Spacer()
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    InfoRow(icon: "drop", title: "test", value: "medium")
}
