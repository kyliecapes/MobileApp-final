//
//  TrackerView.swift
//  Bloom
//
//  Created by Kylie Capes on 11/24/25.
//

import SwiftUI

struct TrackerView: View {
    @StateObject private var viewModel = HabitTrackerViewModel()

    @State private var showingAddHabit = false
    @State private var showingEditHabit = false
    @State private var habitNameInput: String = ""
    @State private var habitToEdit: Habit?

    var body: some View {
        ZStack {
            BloomTheme.background
                .ignoresSafeArea()

            VStack(alignment: .leading, spacing: 16) {

                // Header + Add button
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Bloom 🌸")
                            .font(.system(size: 32, weight: .bold, design: .rounded))
                            .foregroundColor(BloomTheme.accentPink)

                        Text("Daily Tracker")
                            .font(.headline)
                            .foregroundColor(.black.opacity(0.8))
                    }

                    Spacer()

                    Button {
                        habitNameInput = ""
                        showingAddHabit = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                            .foregroundColor(.blue)
                    }
                }
                .padding(.horizontal)
                .padding(.top, 24)

                // ERROR MESSAGE (if any)
                if let error = viewModel.errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                        .font(.footnote)
                        .padding(.horizontal)
                }

                // Habit list (List so swipeActions work)
                List {
                    ForEach(viewModel.habits) { habit in
                        HabitRow(
                            habit: habit,
                            onToggle: {
                                viewModel.toggleCompletion(for: habit)
                            },
                            onDelete: {
                                viewModel.deleteHabit(habit)
                            },
                            onEdit: {
                                habitToEdit = habit
                                habitNameInput = habit.name
                                showingEditHabit = true
                            }
                        )
                        .listRowBackground(Color.clear)
                        .listRowSeparator(.hidden)
                    }
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
                .padding(.top, 8)

                Spacer()

                // Add Note button (placeholder)
                Button(action: {
                    // TODO: open note entry sheet
                }) {
                    Text("Add Note")
                        .font(.system(size: 16, weight: .semibold))
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(12)
                        .shadow(radius: 2, y: 1)
                }
                .padding(.horizontal)
                .padding(.bottom, 8)
            }
        }
        .navigationBarBackButtonHidden(true)
        .sheet(isPresented: $showingAddHabit) {
            HabitFormView(
                title: "Add Habit",
                name: $habitNameInput,
                onCancel: { showingAddHabit = false },
                onSave: {
                    viewModel.addHabit(name: habitNameInput)
                    showingAddHabit = false
                }
            )
        }
        .sheet(isPresented: $showingEditHabit) {
            HabitFormView(
                title: "Edit Habit",
                name: $habitNameInput,
                onCancel: { showingEditHabit = false },
                onSave: {
                    if let habit = habitToEdit {
                        viewModel.updateHabitName(habit, newName: habitNameInput)
                    }
                    showingEditHabit = false
                }
            )
        }
    }
}

// MARK: - Habit Row

struct HabitRow: View {
    let habit: Habit
    var onToggle: () -> Void
    var onDelete: () -> Void
    var onEdit: () -> Void

    var body: some View {
        HStack {
            Button(action: {
                onToggle()
            }) {
                Image(systemName: habit.isCompletedToday ? "checkmark.square.fill" : "square")
                    .font(.title3)
                    .foregroundColor(habit.isCompletedToday ? .green : .gray)
            }

            Text(habit.name)
                .font(.body)
                .foregroundColor(.black)
                .padding(.leading, 4)

            Spacer()

            NavigationLink {
                HabitDetailView(habit: habit)
            } label: {
                Text("Details")
                    .font(.subheadline)
                    .foregroundColor(.blue)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 1, y: 1)
        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
            Button(role: .destructive, action: onDelete) {
                Label("Delete", systemImage: "trash")
            }

            Button(action: onEdit) {
                Label("Edit", systemImage: "pencil")
            }
        }
    }
}

// MARK: - Reusable Habit Form Sheet

struct HabitFormView: View {
    let title: String
    @Binding var name: String
    let onCancel: () -> Void
    let onSave: () -> Void

    var body: some View {
        NavigationStack {
            ZStack {
                BloomTheme.background.ignoresSafeArea()

                VStack(spacing: 20) {
                    TextField("Habit name", text: $name)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(12)
                        .padding(.horizontal)

                    Spacer()
                }
            }
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel", action: onCancel)
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save", action: onSave)
                        .disabled(name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
        }
    }
}
