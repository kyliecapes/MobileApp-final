//
//  HabitTrackerViewModel.swift
//  Bloom
//
//  Created by Kylie Capes on 11/25/25.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class HabitTrackerViewModel: ObservableObject {
    @Published var habits: [Habit] = []
    @Published var errorMessage: String? = nil

    private let db = Firestore.firestore()
    private var listener: ListenerRegistration?

    init() {
        startListeningForHabits()
    }

    deinit {
        listener?.remove()
    }

    // MARK: - Listen for habit changes (live updates)
    func startListeningForHabits() {
        guard let uid = Auth.auth().currentUser?.uid else { return }

        listener = db.collection("users")
            .document(uid)
            .collection("habits")
            .order(by: "name")
            .addSnapshotListener { [weak self] snapshot, error in
                if let error = error {
                    DispatchQueue.main.async {
                        self?.errorMessage = error.localizedDescription
                    }
                    return
                }

                let docs = snapshot?.documents ?? []
                var newHabits: [Habit] = []

                for doc in docs {
                    let data = doc.data()
                    let id = doc.documentID
                    let name = data["name"] as? String ?? ""
                    let isDone = data["isCompletedToday"] as? Bool ?? false

                    let habit = Habit(id: id, name: name, isCompletedToday: isDone)
                    newHabits.append(habit)
                }

                DispatchQueue.main.async {
                    self?.habits = newHabits
                }
            }
    }

    // MARK: - Default habits (used on first login)
    func createDefaultHabits() {
        let defaults = ["Hydration", "Sleep", "Mindfulness", "Workout", "Journaling"]
        for habit in defaults {
            addHabit(name: habit)
        }
    }

    // MARK: - Toggle habit completion
    func toggleCompletion(for habit: Habit) {
        guard let uid = Auth.auth().currentUser?.uid else { return }

        db.collection("users")
            .document(uid)
            .collection("habits")
            .document(habit.id)
            .setData([
                "isCompletedToday": !habit.isCompletedToday
            ], merge: true)
    }

    // MARK: - CRUD FUNCTIONS (Add / Edit / Delete)

    func addHabit(name: String) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let trimmed = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }

        db.collection("users")
            .document(uid)
            .collection("habits")
            .addDocument(data: [
                "name": trimmed,
                "isCompletedToday": false
            ])
    }

    func deleteHabit(_ habit: Habit) {
        guard let uid = Auth.auth().currentUser?.uid else { return }

        db.collection("users")
            .document(uid)
            .collection("habits")
            .document(habit.id)
            .delete()
    }

    func updateHabitName(_ habit: Habit, newName: String) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let trimmed = newName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }

        db.collection("users")
            .document(uid)
            .collection("habits")
            .document(habit.id)
            .setData([
                "name": trimmed
            ], merge: true)
    }
}
