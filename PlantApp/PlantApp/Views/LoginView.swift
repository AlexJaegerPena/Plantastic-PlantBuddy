//
//  LoginView.swift
//  PlantApp
//
//  Created by Alexandra Jäger on 28.05.25.
//

import SwiftUI

struct LoginView: View {
    
    @EnvironmentObject var userViewModel: UserViewModel

    @State private var showRegister = false
    @State private var showPassword = false

    var body: some View {

        if userViewModel.isLoggedIn {
            RootView()
                .environmentObject(userViewModel)
        } else {
            
            ZStack {
                Image("bgSlide")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
            
            VStack {
                Image("mascot")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120)
                    .shadow(color: .black.opacity(0.2), radius: 3, x: 4, y: 4)

                Text("Plantastic")
                    .font(.system(size: 55))
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.white)
                    .padding(.bottom, 80)
                    .shadow(color: .black.opacity(0.3), radius: 3, x: 0, y: 0)
                
                    Text(showRegister ? "Please register to continue" : "Please log in to continue")
                    .foregroundStyle(.white)
                        .font(.system(size: 20))
                        .fontWeight(.light)
                    
                    TextField("Email", text: $userViewModel.email)
                        .padding()
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 30))
                        .padding(.horizontal, 20)
                        .padding(.bottom, 5)
                        //.shadow(color: .black.opacity(0.2), radius: 0, x: 4, y: 4)

                    
                    SecureField("Password", text: $userViewModel.password)
                        .padding()
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 30))
                        .padding(.horizontal, 20)
                        //.shadow(color: .black.opacity(0.2), radius: 0, x: 4, y: 4)
                    
                Text((userViewModel.authError?.errorDescription) ?? "")
                        .foregroundStyle(Color("signalColor"))
                        .padding(.bottom, 20)


                Button {
                    Task {
                        if showRegister {
                            Task {
                                do {
                                    try await userViewModel.registerWithEmailPassword()
                                } catch let error as AuthError {
                                    userViewModel.authError = error
                                }
                            }
                        } else {
                            Task {
                                do {
                                    try await userViewModel.loginEmailPassword()
                                } catch let error as AuthError {
                                    userViewModel.authError = error
                                }
                            }
                        }
                    }
                } label: {
                    Text(showRegister ? "Register" : "Login")
                        .font(.system(size: 24))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                        .foregroundStyle(Color("textColorInverted"))
                }
                .buttonStyle(.borderedProminent)
                .frame(maxWidth: .infinity)
                .tint(Color("textColor"))
                .padding(.horizontal, 20)

                    
                Button(showRegister ? "Got an account?" : "Register here") {
                    showRegister.toggle()
                }
                .foregroundStyle(Color("textColorInverted"))
            }
            .frame(maxWidth: .infinity)
           
        }
    }
}
}

#Preview {
   LoginView()
        .environmentObject(UserViewModel())
}
