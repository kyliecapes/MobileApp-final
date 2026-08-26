//
//  AiTipsViewModel.swift
//  Bloom
//
//  Created by Kylie Capes on 11/30/25.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class AITipsViewModel: ObservableObject {
    @Published var tips: [AITip] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil

    private let db = Firestore.firestore()
    private let service = AITipsService()
    private var listener: ListenerRegistration?

    init() {
        startListeningForTips()
    }

    deinit {
        listener?.remove()
    }

    // Listen to Firestore: users/{uid}/aiTips
    private func startListeningForTips() {
        guard let uid = Auth.auth().currentUser?.uid else { return }

        listener = db.collection("users")
            .document(uid)
            .collection("aiTips")
            .order(by: "createdAt", descending: true)
            .addSnapshotListener { [weak self] snapshot, error in
                if let error = error {
                    DispatchQueue.main.async {
                        self?.errorMessage = error.localizedDescription
                    }
                    return
                }

                let docs = snapshot?.documents ?? []
                var newTips: [AITip] = []

                for doc in docs {
                    let data = doc.data()
                    let id = doc.documentID
                    let title = data["title"] as? String ?? "Suggestion"
                    let goal = data["goal"] as? String ?? ""
                    let suggestion = data["suggestion"] as? String ?? ""
                    let ts = data["createdAt"] as? Timestamp ?? Timestamp(date: Date())
                    let createdAt = ts.dateValue()

                    newTips.append(
                        AITip(
                            id: id,
                            title: title,
                            goal: goal,
                            suggestion: suggestion,
                            createdAt: createdAt
                        )
                    )
                }

                DispatchQueue.main.async {
                    self?.tips = newTips
                }
            }
    }

    // Generate new tips from goals and save them to Firestore
    func generateTips(fromGoals goals: [String], completion: @escaping (Bool) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else {
            completion(false)
            return
        }

        isLoading = true
        errorMessage = nil

        service.generateTips(for: goals) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
            }

            switch result {
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.errorMessage = error.localizedDescription
                }
                completion(false)

            case .success(let tips):
                guard !tips.isEmpty else {
                    completion(true)
                    return
                }

                let batch = self?.db.batch()
                let collection = self?.db
                    .collection("users")
                    .document(uid)
                    .collection("aiTips")

                tips.forEach { tip in
                    if let docRef = collection?.document() {
                        let data: [String: Any] = [
                            "title": tip.title,
                            "goal": tip.goal,
                            "suggestion": tip.suggestion,
                            "createdAt": Timestamp(date: tip.createdAt)
                        ]
                        batch?.setData(data, forDocument: docRef)
                    }
                }

                batch?.commit { error in
                    if let error = error {
                        DispatchQueue.main.async {
                            self?.errorMessage = error.localizedDescription
                        }
                        completion(false)
                    } else {
                        completion(true)
                    }
                }
            }
        }
    }
}
