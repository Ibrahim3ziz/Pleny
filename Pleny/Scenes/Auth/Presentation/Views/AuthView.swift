//
//  AuthView.swift
//  Pleny
//
//  Created by Ibrahim Abdul Aziz on 28/06/2025.
//

import SwiftUI

struct AuthView: View {
    
    @StateObject private var viewModel: AuthViewModel
    @State private var username: String = ""
    @State private var password: String = ""
    
    private var areFieldsValid: Bool {
        !username.trimmingCharacters(in: .whitespaces).isEmpty &&
        !password.trimmingCharacters(in: .whitespaces).isEmpty
    }
    
    init(coordinator: AppCoordinator) {
        _viewModel = StateObject(wrappedValue: AuthViewModel(coordinator: coordinator))
    }
    
    var body: some View {
        ZStack {
            VStack {
                ScrollView {
                    VStack(spacing: 16) {
                        Image(ImageResource.staticLogin)
                            .resizable()
                            .frame(height: 440)
                            .frame(maxWidth: .infinity)
                            .scaledToFit()
                        
                        Text("Welcome")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundStyle(Color("primaryColor"))
                        
                        SimpleInputField(title: "Username", placeholder: "Enter your username", text: $username)
                        
                        SimpleInputField(
                            title: "Password",
                            placeholder: "Enter your password",
                            trailingIcon: "icon-textfield-showPassword",
                            keyboardType: .default,
                            text: $password,
                            isSecureTextEntry: true
                        )
                    }
                }
                
                PlenyButton(
                    btnTitle: "Sign In",
                    btnColor: Color("primaryColor"),
                    btnTitleColor: Color.white,
                    isEnabled: areFieldsValid
                ) {
                    viewModel.login(username: username, password: password)
                }
                .padding(.bottom)
            }
            
            // Centered loading overlay
            if viewModel.isLoading {
                Color.black.opacity(0.1).ignoresSafeArea()
                ProgressView("Loading...")
                    .progressViewStyle(CircularProgressViewStyle())
                    .padding()
                    .background(Color.white)
                    .cornerRadius(12)
                    .shadow(radius: 4)
            }
            
            if viewModel.error != nil { // handle login error.
                ZStack {
                    ErrorView(title: "Login Error", message: "Your username or password is incorrect. Please try again.")
                }
            }
        }
        .ignoresSafeArea(edges: .top)
        .background(Color.white)
    }
}


#Preview {
    AuthView(coordinator: AppCoordinator())
}
