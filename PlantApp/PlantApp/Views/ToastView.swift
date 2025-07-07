//
//  ToastView.swift
//  PlantApp
//
//  Created by Alexandra Jäger on 04.07.25.
//

import SwiftUI

struct ToastView: View {
    
    var style: ToastStyle
    var message: String
//    var onCancelTapped: (() -> Void)
    
    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            Image(systemName: style.iconFileName)
                .foregroundStyle(Color(style.themeColor))
            Text(message)
                .font(.caption)
                .foregroundStyle(Color("textColor"))
            Spacer(minLength: 10)
            Button(role: .cancel) {
            } label: {
                Image(systemName: "xmark")
                    .foregroundStyle(Color(style.themeColor))
            }
        }
        .padding()
        .frame(width: .infinity)
        .background(Color("bgColor"))
        .cornerRadius(8)
        .padding(.horizontal, 16)
    }
}

#Preview {
    ToastView(style: .error, message: "Error Text")
}
