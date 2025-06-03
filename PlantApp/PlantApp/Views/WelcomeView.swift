//
//  WelcomeView.swift
//  PlantApp
//
//  Created by Alexandra Jäger on 02.06.25.
//

import SwiftUI

struct WelcomeView: View {

    @State private var username: String = ""

    @EnvironmentObject var loginViewModel: LoginViewModel
    

    var body: some View {

        if loginViewModel.isRegistrationComplete {
            NavigationView()
                .environmentObject(loginViewModel)
        } else {
            Text("Hello! How should we call you?")
            TextField("Tipe in a name", text: $username)
            Button("Continue") {
                loginViewModel.updateUser(
                    with: loginViewModel.user?.uid, username: username)
                
            }
        }
    }
}

#Preview {
    WelcomeView()
        .environmentObject(LoginViewModel())

}
