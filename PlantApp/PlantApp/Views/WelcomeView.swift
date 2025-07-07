//
//  WelcomeView.swift
//  PlantApp
//
//  Created by Alexandra Jäger on 02.06.25.
//

import SwiftUI

struct WelcomeView: View {

    @EnvironmentObject var userViewModel: UserViewModel

    @State private var newUsername: String = ""

    var body: some View {
        VStack(alignment: .center) {

            Text("Welcome to")
                .font(.system(size: 40))
                .fontWeight(.light)
                .multilineTextAlignment(.center)
                .padding(.top, 60)
            Image("Logo6")
                .resizable()
                .frame(width: 250, height: 250)
                .clipShape(RoundedRectangle(cornerRadius: 40))
            Text("How should we call you?")
                .font(.system(size: 30))
                .fontWeight(.light)
                .foregroundStyle(Color("primaryPetrol"))
                .padding(.top, 60)
            TextField("Tipe in a name", text: $newUsername)
                .font(.system(size: 25))
                .padding()
                .background(Color("bgColor"))
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .padding(.horizontal, 30)
                .padding(.bottom, 10)
                .shadow(
                    color: Color("secondaryPetrol").opacity(0.5), radius: 2,
                    x: 2, y: 2)
            Button {
                userViewModel.username = newUsername  // username in VM aktualisieren
                userViewModel.updateUsername(
                    username: newUsername)  // username in Firestore speichern
            } label: {
                Text("Continue →")
                    .font(.system(size: 24))
            }
            .buttonStyle(.borderedProminent)
            .padding(.leading, 200)
            .tint(newUsername.isEmpty ? Color("secondaryPetrol") : Color("primaryPetrol"))
            .environmentObject(userViewModel)
            Spacer()
        }
    }
}

#Preview {
    WelcomeView()
        .environmentObject(UserViewModel())

}
