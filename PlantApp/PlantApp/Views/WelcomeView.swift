//
//  WelcomeView.swift
//  PlantApp
//
//  Created by Alexandra Jäger on 02.06.25.
//

import SwiftUI

struct WelcomeView: View {
    

    @EnvironmentObject var userViewModel: UserViewModel
    
    @State private var tempUsername: String = ""
    

    var body: some View {

        VStack {
            Text("Hello! How should we call you?")
            TextField("Tipe in a name", text: $tempUsername)
            Button("Continue") {
                userViewModel.username = tempUsername // username in VM aktualisieren
                userViewModel.updateUsername(
                    username: tempUsername) // username in Firestore speichern
                userViewModel.isRegistrationComplete = true
            }
            .environmentObject(userViewModel)
        }
    }
}

#Preview {
    WelcomeView()
        .environmentObject(UserViewModel())

}
