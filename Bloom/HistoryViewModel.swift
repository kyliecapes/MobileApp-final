//
//  HistoryViewModel.swift
//  Bloom
//
//  Created by Kylie Capes on 11/25/25.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class HistoryViewModel: ObservableObject {
    @Published var weeklyTrend: [DailyStat] = []
    @Published var completionRates: [HabitCompletion] = []
    @Published var errorMessage: String? = nil
    @Published var isLoading: Bool = false

    private let db = Firestore.firestore()

    func loadHistory() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        isLoading = true
        errorMessage = nil

        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        guard let startDate = calendar.date(byAdding: .day, value: -6, to: today) else { return }

        db.collection("users")
            .document(uid)
            .collection("dailyEntries")
            .whereField("date", isGreaterThanOrEqualTo: startDate)
            .getDocuments { [weak self] snapshot, error in
                DispatchQueue.main.async {
                    self?.isLoading = false

                    if let error = error {
                        self?.errorMessage = error.localizedDescription
                        return
                    }

                    let docs = snapshot?.documents ?? []
                    self?.processTrendData(docs: docs, startDate: startDate, today: today)
                    self?.processCompletionRates(docs: docs)
                }
            }
    }

    // MARK: - Weekly Line Chart
    private func processTrendData(docs: [QueryDocumentSnapshot], startDate: Date, today: Date) {
        let calendar = Calendar.current
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE"

        var dayValues: [String: Double] = [:]

        for doc in docs {
            let data = doc.data()
            guard
                let timestamp = data["date"] as? Timestamp,
                let valueString = data["value"] as? String
            else { continue }

            let date = timestamp.dateValue()
            let label = formatter.string(from: date)
            let numeric = Double(valueString) ?? 1.0

            dayValues[label, default: 0] += numeric
        }

        var trend: [DailyStat] = []
        for offset in (-6...0) {
            if let d = calendar.date(byAdding: .day, value: offset, to: today) {
                let label = formatter.string(from: d)
                let value = dayValues[label] ?? 0
                trend.append(DailyStat(day: label, value: value))
            }
        }

        self.weeklyTrend = trend
    }

    // MARK: - Completion Rates Per Habit
    private func processCompletionRates(docs: [QueryDocumentSnapshot]) {
        var counter: [String: Int] = [:]

        for doc in docs {
            let habitName = doc.data()["habitName"] as? String ?? "Unknown"
            counter[habitName, default: 0] += 1
        }

        var results: [HabitCompletion] = []
        for (habit, count) in counter {
            let percent = Double(count) / 7.0
            results.append(HabitCompletion(habit: habit, percentage: percent))
        }

        self.completionRates = results.sorted { $0.habit < $1.habit }
    }
}

struct HabitCompletion: Identifiable {
    let id = UUID()
    let habit: String
    let percentage: Double   // 0.0 to 1.0
}
