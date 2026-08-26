//
//  AuthContainerView.swift
//  Bloom
//
//  Created by Kylie Capes on 11/24/25.
//

import SwiftUI

struct AuthContainerView: View {
    @State private var showLogin = true
    
    var body: some View {
        ZStack {
            BloomTheme.background.ignoresSafeArea()
            
            VStack {
                if showLogin {
                    LoginView(onSwitchToSignUp: { showLogin = false })
                } else {
                    SignUpView(onSwitchToLogin: { showLogin = true })
                }
            }
            .animation(.easeInOut, value: showLogin)
        }
    }
}
