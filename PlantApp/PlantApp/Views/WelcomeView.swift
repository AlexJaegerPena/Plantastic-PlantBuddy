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
            Spacer()
            Text("Welcome to")
                .font(.system(size: 40))
                .fontWeight(.light)
                .multilineTextAlignment(.center)
                .padding(.top, 60)
                .foregroundStyle(.white)

            Text("Plantastic")
                .font(.system(size: 55))
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .foregroundStyle(.white)
                .padding(.top, 50)
                .shadow(color: .black.opacity(0.2), radius: 3, x: 0, y: 0)
            Text("Smart plant care made simple")
                .font(.system(size: 20))
                .fontWeight(.light)
                .multilineTextAlignment(.center)
                .foregroundStyle(Color.white)
                .padding(.top, 0)
            Image("mascot")
                .resizable()
                .scaledToFit()
                .frame(width: 150)
                .shadow(color: .black.opacity(0.2), radius: 3, x: 4, y: 4)
                .padding(.top, 4)
            Spacer()
            Text("How should we call you?")
                .font(.system(size: 24))
                .fontWeight(.light)
                .foregroundStyle(.white)
                .padding(.top, 80)
            TextField("Tipe in a name", text: $newUsername)
                .font(.system(size: 20))
                .padding()
                .background(Color("bgColor"))
                .clipShape(RoundedRectangle(cornerRadius: 30))
                .padding(.horizontal, 30)
                .padding(.bottom, 10)
        
            Button {
                userViewModel.username = newUsername  // username in VM aktualisieren
                userViewModel.updateUsername(
                    username: newUsername)  // username in Firestore speichern
            } label: {
                Text("Continue →")
                    .font(.system(size: 20))
            }
            .buttonStyle(.borderedProminent)
            .padding(.leading, 215)
            .tint(newUsername.isEmpty ? Color("textColor").opacity(0.4) : Color("primaryColor"))
            .environmentObject(userViewModel)
            Spacer()
        }
        .background(
            Image("bgSlide")
            .resizable()
            .scaledToFill()
            .frame(width: 450)
        )
    }
}

#Preview {
    WelcomeView()
        .environmentObject(UserViewModel())

}
