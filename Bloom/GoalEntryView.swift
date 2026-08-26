//
//  GoalEntryView.swift
//  Bloom
//
//  Created by Kylie Capes on 11/24/25.
//

import SwiftUI

struct GoalEntryView: View {
    @StateObject private var aiViewModel = AITipsViewModel()

    @State private var goal1: String = ""
    @State private var goal2: String = ""
    @State private var isSubmitting: Bool = false
    @State private var showConfirmation: Bool = false

    var body: some View {
        ZStack {
            BloomTheme.background.ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 20) {

                    // Header
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Bloom 🌸")
                            .font(.system(size: 32, weight: .bold, design: .rounded))
                            .foregroundColor(BloomTheme.accentPink)

                        Text("Create Entry")
                            .font(.headline)
                            .foregroundColor(.black.opacity(0.8))
                    }
                    .padding(.horizontal)
                    .padding(.top, 20)

                    // Goals
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Enter Your Goals:")
                            .font(.headline)

                        VStack(alignment: .leading, spacing: 8) {
                            Text("Goal 1")
                                .font(.subheadline)
                            TextField("e.g. Drink 8 glasses of water daily", text: $goal1)
                                .padding()
                                .background(Color.white)
                                .cornerRadius(12)
                        }

                        VStack(alignment: .leading, spacing: 8) {
                            Text("Goal 2")
                                .font(.subheadline)
                            TextField("e.g. Sleep 8 hours every night", text: $goal2)
                                .padding()
                                .background(Color.white)
                                .cornerRadius(12)
                        }
                    }
                    .padding(.horizontal)

                    if let error = aiViewModel.errorMessage {
                        Text(error)
                            .foregroundColor(.red)
                            .font(.footnote)
                            .padding(.horizontal)
                    }

                    Spacer(minLength: 40)

                    // Submit button
                    Button {
                        submitGoals()
                    } label: {
                        if isSubmitting || aiViewModel.isLoading {
                            ProgressView()
                                .frame(maxWidth: .infinity)
                                .padding()
                        } else {
                            Text("Submit Entry")
                                .font(.system(size: 16, weight: .semibold))
                                .frame(maxWidth: .infinity)
                                .padding()
                        }
                    }
                    .background(Color.black)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                    .padding(.horizontal)
                    .padding(.bottom, 20)
                    .disabled(goal1.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
                              goal2.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
        }
        .alert("Tips Updated!", isPresented: $showConfirmation) {
            Button("OK", role: .cancel) { }
        }
    }

    private func submitGoals() {
        let goals = [goal1, goal2]
        isSubmitting = true

        aiViewModel.generateTips(fromGoals: goals) { success in
            DispatchQueue.main.async {
                isSubmitting = false
                if success {
                    showConfirmation = true
                    goal1 = ""
                    goal2 = ""
                }
            }
        }
    }
}
