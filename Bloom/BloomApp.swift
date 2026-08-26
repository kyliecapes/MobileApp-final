//
//  BloomApp.swift
//  Bloom
//
//  Created by Kylie Capes on 11/24/25.
//

import SwiftUI
import FirebaseCore

@main
struct BloomApp: App {
    @StateObject private var authViewModel = AuthViewModel()
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(authViewModel)
        }
    }
}
