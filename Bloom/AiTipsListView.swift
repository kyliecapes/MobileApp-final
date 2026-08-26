//
//  AiTipsListView.swift
//  Bloom
//
//  Created by Kylie Capes on 11/24/25.
//

import SwiftUI

struct AITipsListView: View {
    @StateObject private var viewModel = AITipsViewModel()

    var body: some View {
        ZStack {
            BloomTheme.background.ignoresSafeArea()

            VStack(alignment: .leading, spacing: 16) {

                // Header
                VStack(alignment: .leading, spacing: 4) {
                    Text("Bloom 🌸")
                        .font(.system(size: 32, weight: .bold, design: .rounded))
                        .foregroundColor(BloomTheme.accentPink)

                    Text("AI Tips")
                        .font(.headline)
                        .foregroundColor(.black.opacity(0.8))
                }
                .padding(.horizontal)
                .padding(.top, 20)

                if let error = viewModel.errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                        .font(.footnote)
                        .padding(.horizontal)
                }

                if viewModel.tips.isEmpty {
                    Text("No tips yet. Add goals on the Entry tab to generate personalized suggestions.")
                        .foregroundColor(.gray)
                        .font(.subheadline)
                        .padding(.horizontal)
                        .padding(.top, 20)

                    Spacer()
                } else {
                    List {
                        ForEach(viewModel.tips) { tip in
                            NavigationLink {
                                AITipDetailView(tip: tip)
                            } label: {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(tip.title)
                                        .font(.headline)
                                    Text(tip.goal)
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                        .lineLimit(1)
                                }
                                .padding(.vertical, 8)
                            }
                        }
                    }
                    .listStyle(.plain)
                    .scrollContentBackground(.hidden)
                }
            }
        }
    }
}
