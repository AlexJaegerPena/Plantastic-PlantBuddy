//
//  SettingsView.swift
//  PlantApp
//
//  Created by Alexandra Jäger on 26.05.25.
//

import SwiftUI

struct SettingsView: View {
    
    @EnvironmentObject var loginViewModel: LoginViewModel
    @StateObject var settingsViewModel = SettingsViewModel()
    
    
    var body: some View {
        List {
            Section("Profile") {
//                TextField("Username", text: $loginViewModel.username ?? "")
                TextField("Email", text: $loginViewModel.email)
                TextField("Password", text: $loginViewModel.password)
            }
            Section("App settings") {
                Text("Darkmode")
                Text("Language preferences")
            }
            Section("Support") {
                Button {
                    
                } label: {
                    Label("Website", systemImage: "globe")
                }
                Button {
                    
                } label: {
                    Label("Contact us", systemImage: "envelope")
                }
            }
            Button("Logout") {
                settingsViewModel.logout()
                loginViewModel.email = ""
                loginViewModel.password = ""
            }
        }
    }
}

#Preview {
    SettingsView()
        .environmentObject(LoginViewModel())

}
