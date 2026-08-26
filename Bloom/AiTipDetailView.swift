//
//  AiTipDetailView.swift
//  Bloom
//
//  Created by Kylie Capes on 11/24/25.
//

import SwiftUI

struct AITipDetailView: View {
    let tip: AITip

    var body: some View {
        ZStack {
            BloomTheme.background.ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 20) {

                    // Header
                    VStack(alignment: .leading, spacing: 4) {
                        Text(tip.title)
                            .font(.title2.bold())
                        Text("Goal: \(tip.goal)")
                            .font(.subheadline)
                            .foregroundColor(.black.opacity(0.7))
                    }
                    .padding(.horizontal)
                    .padding(.top, 20)

                    // Suggestion text
                    VStack(alignment: .leading, spacing: 8) {
                        Text("AI Suggestion")
                            .font(.headline)

                        Text(tip.suggestion)
                            .font(.body)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(12)
                    }
                    .padding(.horizontal)

                    Spacer(minLength: 40)
                }
            }
        }
    }
}

