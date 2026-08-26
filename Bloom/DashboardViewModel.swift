//
//  DashboardViewModel.swift
//  Bloom
//
//  Created by Kylie Capes on 11/25/25.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class DashboardViewModel: ObservableObject {
    @Published var habits: [String] = ["Hydration", "Sleep", "Mindfulness", "Workout", "Journaling"]
    @Published var selectedHabit: String = "Hydration"
    @Published var weeklyData: [DailyStat] = []
    @Published var completionRate: Double = 0.0   // 0.0 - 1.0
    @Published var currentStreak: Int = 0         // days
    @Published var errorMessage: String? = nil
    @Published var isLoading: Bool = false

    private let db = Firestore.firestore()

    init() {
        loadWeeklyData()
    }

    func loadWeeklyData() {
        guard let uid = Auth.auth().currentUser?.uid else {
            errorMessage = "No user logged in."
            return
        }

        isLoading = true
        errorMessage = nil

        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        guard let startDate = calendar.date(byAdding: .day, value: -6, to: today) else { return }

        db.collection("users")
            .document(uid)
            .collection("dailyEntries")
            .whereField("habitName", isEqualTo: selectedHabit)
            .whereField("date", isGreaterThanOrEqualTo: startDate)
            .getDocuments { [weak self] snapshot, error in
                DispatchQueue.main.async {
                    self?.isLoading = false

                    if let error = error {
                        self?.errorMessage = error.localizedDescription
                        self?.weeklyData = []
                        self?.completionRate = 0
                        self?.currentStreak = 0
                        return
                    }

                    let docs = snapshot?.documents ?? []

                    let formatter = DateFormatter()
                    formatter.dateFormat = "EEE"  // Mon, Tue, etc.

                    var dayValues: [String: Double] = [:]

                    for doc in docs {
                        let data = doc.data()
                        guard let timestamp = data["date"] as? Timestamp else { continue }
                        let date = timestamp.dateValue()
                        let dayLabel = formatter.string(from: date)

                        let rawValue = data["value"] as? String ?? ""
                        let numeric = Double(rawValue) ?? 1.0

                        dayValues[dayLabel, default: 0.0] += numeric
                    }

                    var result: [DailyStat] = []
                    for offset in (-6...0) {
                        if let dayDate = calendar.date(byAdding: .day, value: offset, to: today) {
                            let label = formatter.string(from: dayDate)
                            let value = dayValues[label] ?? 0
                            result.append(DailyStat(day: label, value: value))
                        }
                    }

                    self?.weeklyData = result
                    self?.updateSummaryStats(from: result)
                }
            }
    }

    private func updateSummaryStats(from data: [DailyStat]) {
        guard !data.isEmpty else {
            completionRate = 0
            currentStreak = 0
            return
        }

        // completion % = days with any value > 0
        let daysWithData = data.filter { $0.value > 0 }.count
        completionRate = Double(daysWithData) / Double(data.count)

        // streak = consecutive days from latest going backwards with value > 0
        var streak = 0
        for item in data.reversed() {
            if item.value > 0 {
                streak += 1
            } else {
                break
            }
        }
        currentStreak = streak
    }
}
