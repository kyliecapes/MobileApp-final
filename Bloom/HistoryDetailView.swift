//
//  HistoryDetailView.swift
//  Bloom
//
//  Created by Kylie Capes on 11/24/25.
//

import SwiftUI
import Charts

struct HistoryDetailView: View {
    @StateObject private var viewModel = HistoryViewModel()

    var body: some View {
        ZStack {
            BloomTheme.background.ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 20) {

                    // HEADER
                    VStack(alignment: .leading, spacing: 4) {
                        Text("History Detail")
                            .font(.title2.bold())
                            .foregroundColor(.black)
                        Text("Last 7 Days")
                            .font(.subheadline)
                            .foregroundColor(.black.opacity(0.7))
                    }
                    .padding(.horizontal)
                    .padding(.top, 20)

                    // WEEKLY TREND CHART
                    VStack(alignment: .leading) {
                        Text("History Overview")
                            .font(.headline)

                        if viewModel.isLoading {
                            ProgressView()
                                .frame(height: 200)
                        } else if viewModel.weeklyTrend.isEmpty {
                            Text("No data available.")
                                .foregroundColor(.gray)
                                .frame(height: 200)
                        } else {
                            Chart(viewModel.weeklyTrend) { item in
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

                    // COMPLETION RATES
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Completion Rates by Habit")
                            .font(.headline)

                        if viewModel.completionRates.isEmpty {
                            Text("No completion data yet.")
                                .foregroundColor(.gray)
                        } else {
                            ForEach(viewModel.completionRates) { item in
                                HStack {
                                    Text(item.habit)
                                        .font(.body)

                                    Spacer()

                                    Text("\(Int(item.percentage * 100))%")
                                        .bold()
                                        .foregroundColor(.blue)
                                }
                                .padding()
                                .background(Color.white)
                                .cornerRadius(12)
                                .shadow(radius: 1, y: 1)
                            }
                        }
                    }
                    .padding(.horizontal)

                    Spacer(minLength: 40)
                }
            }
        }
        .onAppear {
            viewModel.loadHistory()
        }
    }
}
