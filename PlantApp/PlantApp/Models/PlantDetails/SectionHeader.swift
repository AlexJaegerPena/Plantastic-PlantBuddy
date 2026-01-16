//
//  SectionHeaderView.swift
//  PlantApp
//
//  Created by Alexandra Jäger on 30.06.25.
//

import SwiftUI

struct SectionHeader: View {
    let title: String
    let icon: String

    var body: some View {
        HStack {
//            Image(systemName: icon)
//                .foregroundStyle(Color("primaryColor"))
//                .font(.system(size: 20))
            Text(title)
                .foregroundStyle(Color("textColor"))
                .font(.title3)
                .fontWeight(.semibold)
            Spacer()
        }
        .padding(.horizontal)
        .padding(.top, 10)
    }
}

#Preview {
    SectionHeader(title: "Test", icon: "drop")
}


