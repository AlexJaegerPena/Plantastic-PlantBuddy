//
//  WelcomeView.swift
//  PlantApp
//
//  Created by Alexandra Jäger on 02.06.25.
//

import SwiftUI

struct WelcomeView: View {

    @State private var username: String = ""

    @EnvironmentObject var userViewModel: UserViewModel
    

    var body: some View {

        if userViewModel.isRegistrationComplete {
            NavigationView()
                .environmentObject(userViewModel)
        } else {
            Text("Hello! How should we call you?")
            TextField("Tipe in a name", text: $username)
            Button("Continue") {
                userViewModel.updateUsername(
                    username: username)
                
            }
        }
    }
}

#Preview {
    WelcomeView()
        .environmentObject(UserViewModel())

}
