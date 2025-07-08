//
//  LoadingScreenView.swift
//  PlantApp
//
//  Created by Alexandra Jäger on 24.06.25.
//

import SwiftUI

struct LoadingScreenView: View {
    
    @EnvironmentObject var userViewModel: UserViewModel
    
    @AppStorage("hasAppeared") private var hasAppeared = false
    @State private var showOverlay = false
        
    var body: some View {
        ZStack {
            Image(showOverlay ? "welcome2" : "welcome1")
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 50)
                .padding(.bottom, 50)
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
                .fontDesign(.serif)

                .padding(.bottom, 340)
            
//            Text(hasAppeared ? "Welcome back, Green Thumb!" : "Your green journey starts now")
//                .font(.system(size: 25))
//                .foregroundStyle(.white)
//                .fontWeight(.regular)
//                .fontDesign(.serif)
//                .multilineTextAlignment(.center)
//                .padding(.top, 450)
            Spacer()
            Spacer()
        }
        .background(
            Image("bgSlide")
            .resizable()
            .scaledToFill()
            .frame(width: 450)
        )
        .onDisappear {
            hasAppeared = true
        }
    }
}

#Preview {
    LoadingScreenView()
        .environmentObject(UserViewModel())
}
