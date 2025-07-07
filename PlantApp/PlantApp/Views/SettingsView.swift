//
//  SettingsView.swift
//  PlantApp
//
//  Created by Alexandra Jäger on 26.05.25.
//

import SwiftUI
import Foundation

struct SettingsView: View {
    
    
    @StateObject var settingsViewModel = SettingsViewModel()
    @StateObject var notificationsViewModel = NotificationsViewModel()
    @EnvironmentObject var userViewModel: UserViewModel
    
    @State private var editing = false
    @State private var showPassword = false
    @State private var selectedLanguage: String = "ENG"
    @State private var languages: [String] = ["ENG", "DE", "ESP"]
    @State private var showNotificationSheet = false
    @State private var showDeleteNotification = false
    
    @State private var date = Date()
    var getTimeFromDate: [String] {
        date.formatted(date: .omitted, time: .shortened).components(separatedBy: ":")
    }
    
    @Environment(\.darkModeEnabled) var darkModeEnabled: Binding<Bool>

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
                    Toggle("Dark Mode", isOn: darkModeEnabled)
                    VStack(alignment: .leading) {
                        Toggle("Enable Notifications", isOn: $notificationsViewModel.allowNotifications)
                            .onChange(of: notificationsViewModel.allowNotifications) {
                                notificationsViewModel.requestPermission()
                            }
                        if notificationsViewModel.allowNotifications {
                            VStack {
                                DatePicker("Set Time", selection: $date, displayedComponents: .hourAndMinute)
                                
                                Button {
                                    notificationsViewModel.wateringNotification(hour: Int(getTimeFromDate[0]) ?? 0, minute: Int(getTimeFromDate[1]) ?? 0)
                                    showNotificationSheet = true
                                } label: {
                                    HStack {
                                        Text("Confirm")
                                            .foregroundStyle(.white)
                                            .padding(.vertical, 6)
                                            .padding(.horizontal, 20)
                                            .background(Color("primaryPetrol"))
                                            .clipShape(RoundedRectangle(cornerRadius: 10))
                                    }
                                    .buttonStyle(.borderedProminent)
                                }
                            }
                            .padding(.leading, 15)
                        }
                    }
                    
                    Picker("Select Language", selection: $selectedLanguage) {
                        ForEach(languages, id:\.self) { language in
                            Text(language).tag(language)
                        }
                    }
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
                Button {
                    settingsViewModel.logout()
                    userViewModel.email = ""
                    userViewModel.password = ""
                    userViewModel.username = ""
                } label: {
                    HStack {
                        Image(systemName: "rectangle.portrait.and.arrow.right")
                        Text("Logout")
                    }
                }
                
                Button(role: .destructive) {
                    showDeleteNotification = true
                } label: {
                    HStack {
                        Text("Delete Account")
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        editing.toggle()
                        userViewModel.updateUsername(username: userViewModel.username)
                    } label: {
                        Image(systemName: editing ? "checkmark.square" : "square.and.pencil")
                    }
                }
            }
            .alert("Success!", isPresented: $showNotificationSheet) {
                
            } message: {
                Text("Notifications successfully set.")
            }
            .alert("Do you really want to delete your account?", isPresented: $showDeleteNotification) {
                Button("Delete", role: .destructive) {
                        Task {
                            userViewModel.deleteUser(userViewModel.userId)
                    }
                }
            } message: {
                Text("You can NOT undo this action.")
            }
        }
    }


#Preview {
    SettingsView()
        .environmentObject(UserViewModel())
}
