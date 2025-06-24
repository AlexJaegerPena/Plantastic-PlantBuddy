//
//  LoadingScreenView.swift
//  PlantApp
//
//  Created by Alexandra Jäger on 24.06.25.
//

import SwiftUI

struct LoadingScreenView: View {
    
    @EnvironmentObject var userViewModel: UserViewModel
    
    var body: some View {
        VStack {
            Image("Logo")
                .resizable()
                .scaledToFit()
                .frame(width: .infinity, height: 260)
                .clipShape(RoundedRectangle(cornerRadius: 60))
                .padding(.vertical, 40)
            
            Text("Welcome back, \n\(userViewModel.username)!")
                .font(.system(size: 40))
                .fontWeight(.light)
            Spacer()
        }
    }
}

#Preview {
    LoadingScreenView()
        .environmentObject(UserViewModel())
}
