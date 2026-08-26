//
//  DashboardView.swift
//  Bloom
//
//  Created by Kylie Capes on 11/24/25.
//
import SwiftUI
import Charts

struct DashboardView: View {
    @StateObject private var viewModel = DashboardViewModel()

    var body: some View {
        ZStack {
            BloomTheme.background
                .ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 20) {

                    // HEADER
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Bloom 🌸")
                            .font(.system(size: 32, weight: .bold, design: .rounded))
                            .foregroundColor(BloomTheme.accentPink)

                        Text("Dashboard")
                            .font(.headline)
                            .foregroundColor(.black.opacity(0.8))
                    }
                    .padding(.horizontal)
                    .padding(.top, 20)

                    // Habit Picker Card
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Select Habit")
                            .font(.headline)

                        Picker("Habit", selection: $viewModel.selectedHabit) {
                            ForEach(viewModel.habits, id: \.self) { habit in
                                Text(habit).tag(habit)
                            }
                        }
                        .pickerStyle(.menu)
                        .onChange(of: viewModel.selectedHabit, initial: false) { _,_  in
                            viewModel.loadWeeklyData()
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(12)
                        .shadow(radius: 1, y: 1)
                    }
                    .padding(.horizontal)

                    // Error message
                    if let error = viewModel.errorMessage {
                        Text(error)
                            .foregroundColor(.red)
                            .font(.footnote)
                            .padding(.horizontal)
                    }

                    // SUMMARY CARD (completion + streak)
                    VStack(alignment: .leading, spacing: 12) {
                        Text("This Week")
                            .font(.headline)

                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Completion")
                                    .font(.subheadline)
                                    .foregroundColor(.black.opacity(0.7))
                                Text("\(Int(viewModel.completionRate * 100))%")
                                    .font(.title3.bold())
                            }

                            Spacer()

                            VStack(alignment: .leading, spacing: 4) {
                                Text("Current Streak")
                                    .font(.subheadline)
                                    .foregroundColor(.black.opacity(0.7))
                                Text("\(viewModel.currentStreak) day\(viewModel.currentStreak == 1 ? "" : "s")")
                                    .font(.title3.bold())
                            }
                        }
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(16)
                    .shadow(radius: 2, y: 2)
                    .padding(.horizontal)

                    // Chart Card
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Weekly Trend")
                            .font(.headline)

                        if viewModel.isLoading {
                            ProgressView()
                                .frame(height: 200)
                        } else if viewModel.weeklyData.isEmpty {
                            Text("No data yet for this habit.\nTry saving an entry!")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                                .frame(height: 200)
                        } else {
                            Chart(viewModel.weeklyData) { item in
                                LineMark(
                                    x: .value("Day", item.day),
                                    y: .value("Value", item.value)
                                )
                                PointMark(
                                    x: .value("Day", item.day),
                                    y: .value("Value", item.value)
                                )
                            }
                            .frame(height: 200)
                        }
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(16)
                    .shadow(radius: 2, y: 2)
                    .padding(.horizontal)

                    // View Full History Button
                    NavigationLink {
                        HistoryDetailView()
                    } label: {
                        Text("View Full History")
                            .font(.system(size: 16, weight: .semibold))
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(12)
                            .shadow(radius: 1, y: 1)
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 20)
                }
            }
        }
    }
}

// Shared model for charts
struct DailyStat: Identifiable {
    let id = UUID()
    let day: String
    let value: Double
}
