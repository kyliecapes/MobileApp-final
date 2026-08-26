//
//  SplashView.swift
//  Bloom
//
//  Created by Kylie Capes on 11/24/25.
//

import SwiftUI

struct SplashView: View {
    let onFinished: () -> Void
    
    @State private var isVisible = false

    var body: some View {
        ZStack {
            BloomTheme.background
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                Text("Bloom")
                    .font(.system(size: 40, weight: .bold, design: .rounded))
                    .foregroundColor(BloomTheme.accentPink)
                    .scaleEffect(isVisible ? 1.0 : 0.8)
                    .opacity(isVisible ? 1.0 : 0.0)
                
                Text("Self-care Habit Tracker")
                    .font(.headline)
                    .foregroundColor(.black.opacity(0.8))
                    .opacity(isVisible ? 1.0 : 0.0)
                
                Spacer().frame(height: 40)
                
                VStack(spacing: 4) {
                    Text("Kylie Capes")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                    
                    Text("Z23682486")     
                        .font(.subheadline)
                        .foregroundColor(.black.opacity(0.7))
                }
                .opacity(isVisible ? 1.0 : 0.0)
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.8)) {
                isVisible = true
            }
            
            // After 2 seconds, move on to the app
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                onFinished()
            }
        }
    }
}
