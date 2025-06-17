//
//  SettingsView.swift
//  PlantApp
//
//  Created by Alexandra Jäger on 26.05.25.
//

import SwiftUI

struct SettingsView: View {
    
    @EnvironmentObject var userViewModel: UserViewModel
    @StateObject var settingsViewModel = SettingsViewModel()
    
    @State var showPassword: Bool = false
    
    
    var body: some View {
        List {
            Section("Profile") {
                TextField("Username", text: $userViewModel.username)
                TextField("Email", text: $userViewModel.email)
                VStack {
                    if showPassword {
                        TextField("Password", text: $userViewModel.password)
                    } else {
                        SecureField("Password", text: $userViewModel.password)
                    }
                        
                }
                .overlay {
                    HStack {
                        Spacer()
                        Button {
                            showPassword.toggle()
                        } label: {
                            Image(systemName: showPassword ? "eye.slash" : "eye")
                        }
                    }
                }
                

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
                userViewModel.email = ""
                userViewModel.password = ""
            }
        }
    }
}

#Preview {
    SettingsView()
        .environmentObject(UserViewModel())

}
