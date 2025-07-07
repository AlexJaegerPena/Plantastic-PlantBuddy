//
//  LoadingScreenView.swift
//  PlantApp
//
//  Created by Alexandra Jäger on 24.06.25.
//

import SwiftUI

struct LoadingScreenView: View {
    
    @EnvironmentObject var userViewModel: UserViewModel
    
    @State private var hasAppeared = false
        
    var body: some View {
        VStack {
            Image("Logo6")
                .resizable()
                .scaledToFit()
                .frame(width: .infinity, height: 260)
                .clipShape(RoundedRectangle(cornerRadius: 60))
                .padding(.vertical, 40)
            
            Text("Hey \(userViewModel.username)!👋")
                .font(.system(size: 40))
                .fontWeight(.light)
                .foregroundStyle(Color("primaryPetrol"))
                .multilineTextAlignment(.center)
                .padding(.bottom, 20)
            Text(hasAppeared ? "Welcome back, Green Thumb!" : "Your green journey starts now")
                .font(.system(size: 25))
                .foregroundStyle(Color("secondaryPetrol"))
                .fontWeight(.light)
                .multilineTextAlignment(.center)
            Spacer()
        }
        .onDisappear {
            hasAppeared = true
        }
    }
}

#Preview {
    LoadingScreenView()
        .environmentObject(UserViewModel())
}
