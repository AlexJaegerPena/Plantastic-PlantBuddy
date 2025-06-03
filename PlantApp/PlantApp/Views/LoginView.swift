//
//  LoginView.swift
//  PlantApp
//
//  Created by Alexandra Jäger on 28.05.25.
//

import SwiftUI

struct LoginView: View {
    
    @StateObject private var loginViewModel = LoginViewModel()
    @State private var showRegister = false
    
    
    var body: some View {
        if loginViewModel.isLoggedIn {
            NavigationView()
                .environmentObject(loginViewModel)
        } else {
            VStack {
                TextField("Email", text: $loginViewModel.email)
                    .textFieldStyle(.roundedBorder)
                SecureField("Password", text: $loginViewModel.password)
                    .textFieldStyle(.roundedBorder)
                Button(showRegister ? "Register" : "Login") {
                    showRegister
                    ? loginViewModel.registerWithEmailPassword()
                    : loginViewModel.signInEmailPassword()
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
