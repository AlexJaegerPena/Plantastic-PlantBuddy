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
    
    @State private var editing: Bool = false
    @State private var showPassword: Bool = false
    @State private var darkMode: Bool = false
    
    @Environment(\.openURL) private var openUrl
    
    
    var body: some View {
        List {
            Section("Profile") {
                if editing {
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
                } else {
                    Text(userViewModel.username)
                    Text(userViewModel.email)
                    Text("******")
                }
            }

            
            
            Section("App settings") {
                Toggle("Dark mode", isOn: $darkMode)
                    .onChange(of: darkMode) {
                        UIApplication.shared.connectedScenes
                            .compactMap { $0 as? UIWindowScene }
                            .first?.windows
                            .first?.overrideUserInterfaceStyle = darkMode ? .dark : .light
                    }
                
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
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    editing.toggle()
                } label: {
                    Image(systemName: "pencil")
                }
            }
        }
    }
}

#Preview {
    SettingsView()
        .environmentObject(UserViewModel())

}
