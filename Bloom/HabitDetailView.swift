//
//  HabitDetailView.swift
//  Bloom
//
//  Created by Kylie Capes on 11/24/25.
//

import SwiftUI

struct HabitDetailView: View {
    let habit: Habit

    @Environment(\.dismiss) private var dismiss

    // Service to talk to Firestore
    private let entryService = DailyEntryService()

    // User input state
    @State private var valueText: String = ""
    @State private var notesText: String = ""

    // Saving state
    @State private var isSaving: Bool = false
    @State private var showSavedAlert: Bool = false

    var body: some View {
        ZStack {
            BloomTheme.background.ignoresSafeArea()

            VStack(spacing: 0) {

                // TOP CUSTOM HEADER
                VStack(alignment: .leading, spacing: 16) {

                    // Back row
                    Button {
                        dismiss()
                    } label: {
                        HStack(spacing: 4) {
                            Image(systemName: "chevron.left")
                            Text("Back")
                        }
                        .font(.subheadline)
                        .foregroundColor(.blue)
                    }

                    // Icon + habit name row
                    HStack(spacing: 8) {
                        Image(systemName: iconName(for: habit.name))
                            .foregroundColor(.blue)
                            .font(.title3)

                        Text(habit.name)
                            .font(.title2.bold())
                    }
                }
                .padding(.horizontal)
                .padding(.top, 12)

                Divider()
                    .padding(.bottom, 12)

                // MAIN CONTENT SCROLL
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {

                        // VALUE TODAY
                        VStack(alignment: .leading, spacing: 6) {
                            Text("\(habit.name) Value Today:")
                                .font(.headline)

                            TextField(placeholderText(for: habit.name), text: $valueText)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 8)
                                .background(Color.white)
                                .cornerRadius(10)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.gray.opacity(0.2))
                                )
                        }

                        // NOTES
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Notes:")
                                .font(.headline)

                            ZStack(alignment: .topLeading) {
                                TextEditor(text: $notesText)
                                    .frame(minHeight: 140)
                                    .padding(8)
                                    .background(Color.white)
                                    .cornerRadius(10)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(Color.gray.opacity(0.15))
                                    )

                                if notesText.isEmpty {
                                    Text("Add any notes about your \(habit.name.lowercased()) today...")
                                        .foregroundColor(.gray.opacity(0.6))
                                        .padding(.horizontal, 16)
                                        .padding(.vertical, 16)
                                }
                            }
                        }

                        Spacer(minLength: 40)
                    }
                    .padding(.horizontal)
                }

                // SAVE BUTTON AT BOTTOM
                Button {
                    saveEntry()
                } label: {
                    if isSaving {
                        ProgressView()
                            .frame(maxWidth: .infinity)
                            .padding()
                    } else {
                        Text("Save")
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
                .padding(.bottom, 8)
            }
        }
        .navigationBarBackButtonHidden(true)
        .alert("Entry Saved!", isPresented: $showSavedAlert) {
            Button("OK") {
                dismiss()
            }
        }
        .onAppear {
            loadLatestEntry()
        }
    }

    // MARK: - Helpers

    private func saveEntry() {
        isSaving = true

        entryService.saveEntry(
            habitID: habit.id,
            habitName: habit.name,
            value: valueText,
            notes: notesText
        ) { error in
            DispatchQueue.main.async {
                self.isSaving = false
                if let error = error {
                    print("Error saving entry:", error.localizedDescription)
                } else {
                    self.showSavedAlert = true
                    self.valueText = ""
                    self.notesText = ""
                }
            }
        }
    }

    private func loadLatestEntry() {
        entryService.fetchLatestEntry(forHabitID: habit.id) { entry in
            DispatchQueue.main.async {
                if let entry = entry {
                    self.valueText = entry.value
                    self.notesText = entry.notes
                }
            }
        }
    }

    private func iconName(for habitName: String) -> String {
        switch habitName.lowercased() {
        case "hydration":
            return "drop.fill"
        case "sleep":
            return "moon.zzz.fill"
        case "mindfulness":
            return "sparkles"
        case "workout":
            return "figure.walk"
        case "journaling":
            return "book.closed.fill"
        default:
            return "star.fill"
        }
    }

    private func placeholderText(for habitName: String) -> String {
        switch habitName.lowercased() {
        case "hydration":
            return "e.g. 8 glasses"
        case "sleep":
            return "e.g. 8 hours"
        case "workout":
            return "e.g. 30 mins"
        default:
            return "e.g. enter today’s value"
        }
    }
}
