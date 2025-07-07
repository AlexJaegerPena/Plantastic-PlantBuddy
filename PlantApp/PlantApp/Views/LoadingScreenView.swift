//
//  LoadingScreenView.swift
//  PlantApp
//
//  Created by Alexandra Jäger on 24.06.25.
//

import SwiftUI

struct LoadingScreenView: View {
    
    @EnvironmentObject var userViewModel: UserViewModel
    
//    @State private var hasAppeared = false
    @AppStorage("hasAppeared") private var hasAppeared = false
    @State private var showOverlay = false
        
    var body: some View {
        ZStack {
            
            Image(showOverlay ? "welcome2" : "welcome1")
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 40)
                .padding(.bottom, 60)
                .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                    showOverlay = true
                            }
                        }
            
            Text("Hey \(userViewModel.username)!👋")
                .font(.system(size: 30))
                .fontWeight(.medium)
                .foregroundStyle(Color("textColor"))
                .multilineTextAlignment(.center)
                .padding(.bottom, 365)
            
            Text(hasAppeared ? "Welcome back, Green Thumb!" : "Your green journey starts now")
                .font(.system(size: 25))
                .foregroundStyle(Color("primaryPetrol"))
                .fontWeight(.medium)
//                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .padding(.top, 450)
            Spacer()
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
