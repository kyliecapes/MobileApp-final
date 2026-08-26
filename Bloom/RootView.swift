//
//  RootView.swift
//  Bloom
//
//  Created by Kylie Capes on 11/24/25.
//

import SwiftUI

struct RootView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var showSplash = true

    var body: some View {
        Group {
            if showSplash {
                SplashView {
                    withAnimation {
                        showSplash = false
                    }
                }
            } else {
                if authViewModel.isAuthenticated {
                    MainTabView()
                } else {
                    AuthContainerView()
                }
            }
        }
    }
}
