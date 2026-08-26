//
//  LoginView.swift
//  Bloom
//
//  Created by Kylie Capes on 11/24/25.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    
    @State private var email = ""
    @State private var password = ""
    
    let onSwitchToSignUp: () -> Void
    
    var body: some View {
        VStack(spacing: 24) {
            
            // Header
            VStack(spacing: 4) {
                Text("Bloom")
                    .font(.system(size: 36, weight: .bold, design: .rounded))
                    .foregroundColor(BloomTheme.accentPink)
                
                Text("Welcome back")
                    .font(.headline)
                    .foregroundColor(.black.opacity(0.8))
            }
            .padding(.top, 40)
            
            // Fields
            VStack(spacing: 16) {
                TextField("Email", text: $email)
                    .keyboardType(.emailAddress)
                    .textInputAutocapitalization(.never)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(12)
                
                SecureField("Password", text: $password)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(12)
            }
            .padding(.horizontal)
            
            // Error
            if let error = authViewModel.authError {
                Text(error)
                    .foregroundColor(.red)
                    .font(.footnote)
                    .padding(.horizontal)
            }
            
            // Login button
            Button {
                authViewModel.logIn(email: email, password: password)
            } label: {
                if authViewModel.isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity)
                        .padding()
                } else {
                    Text("Log In")
                        .font(.system(size: 16, weight: .semibold))
                        .frame(maxWidth: .infinity)
                        .padding()
                }
            }
            .background(Color.black)
            .foregroundColor(.white)
            .cornerRadius(12)
            .padding(.horizontal)
            .padding(.top, 8)
            
            // Switch to signup
            Button(action: onSwitchToSignUp) {
                Text("Don’t have an account? Sign up")
                    .font(.footnote)
                    .foregroundColor(.blue)
            }
            
            Spacer()
        }
    }
}
