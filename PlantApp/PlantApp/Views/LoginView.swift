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
    @State private var isActive = false
    @State private var authError: AuthError?
    @State private var showPassword = false


    var body: some View {

        if userViewModel.isLoggedIn {
            RootView()
                .environmentObject(userViewModel)
        } else {
            VStack {
                    Image("Logo6")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 250, height: 250)
                    Text(showRegister ? "Please register to continue" : "Please log in to continue")
                        .foregroundStyle(Color("primaryPetrol"))
                        .font(.system(size: 20))
                        .fontWeight(.light)
                    
                    TextField("Email", text: $userViewModel.email)
                        .padding()
                        .background(Color("bgColor"))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .padding(.horizontal, 20)
                        .padding(.bottom, 10)
                        .shadow(
                            color: Color("secondaryPetrol").opacity(0.5), radius: 2,
                            x: 2, y: 2)
                    
                    SecureField("Password", text: $userViewModel.password)
                        .padding()
                        .background(Color("bgColor"))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .padding(.horizontal, 20)
                        .padding(.bottom, 10)
                        .shadow(
                            color: Color("secondaryPetrol").opacity(0.5), radius: 2,
                            x: 2, y: 2)
                    
                    Text((authError?.errorDescription) ?? "")
                        .foregroundStyle(.red)

                
                    Button {
                        Task {
                            if showRegister {
                                Task {
                                    do {
                                        try await userViewModel.registerWithEmailPassword()
                                    } catch let error as AuthError {
                                        authError = error
//                                        showError = true
                                    }
                                }
                            } else {
                                Task {
                                    do {
                                        try await userViewModel.loginEmailPassword()
                                    } catch let error as AuthError {
                                        authError = error
//                                        showError = true
                                    }
                                }
                            }
                        }
                    } label: {
                        Text(showRegister ? "Register" : "Login")
                            .font(.system(size: 24))
                            .padding(.horizontal, 30)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(isActive ? Color("secundaryPetrol") : Color("primaryPetrol"))
                    .padding(.top, 15)
                    
                   
                    Button(showRegister ? "Got an account?" : "Register here") {
                        showRegister.toggle()
                    }
                    .foregroundStyle(Color("secondaryPetrol"))
            }
            .padding()
        }
    }
}

#Preview {
   LoginView()
        .environmentObject(UserViewModel())
}
