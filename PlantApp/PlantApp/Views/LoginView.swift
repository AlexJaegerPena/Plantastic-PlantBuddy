//
//  LoginView.swift
//  PlantApp
//
//  Created by Alexandra Jäger on 28.05.25.
//

import SwiftUI

struct LoginView: View {
    
    @StateObject private var userViewModel = UserViewModel()

    @State private var showRegister = false

    
    
    var body: some View {
//        if !userViewModel.isAuthStatusChecked {
//            ProgressView("Lade...")
//        } else
        if userViewModel.isLoggedIn {
            NavView()
                .environmentObject(userViewModel)
        } else {
            VStack {
                TextField("Email", text: $userViewModel.email)
                    .textFieldStyle(.roundedBorder)
                SecureField("Password", text: $userViewModel.password)
                    .textFieldStyle(.roundedBorder)
                Button(showRegister ? "Register" : "Login") {
                    Task {
                        if showRegister {
                            await userViewModel.registerWithEmailPassword(email: userViewModel.email, password: userViewModel.password)
                        } else {
                            await
                            userViewModel.loginEmailPassword(email: userViewModel.email, password: userViewModel.password)
                        }
                    }
                }
            }
            HStack {
                Button(showRegister ? "Got an account?" : "Register here") {
                    showRegister.toggle()
                }
                Spacer()
            }
        }
    }
}

#Preview {
   LoginView()
}
