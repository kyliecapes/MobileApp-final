//
//  DailyEntryService.swift
//  Bloom
//
//  Created by Kylie Capes on 11/25/25.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class DailyEntryService {
    private let db = Firestore.firestore()
    
    func saveEntry(
        habitID: String,
        habitName: String,
        value: String,
        notes: String,
        completion: @escaping (Error?) -> Void
    ) {
        guard let uid = Auth.auth().currentUser?.uid else {
            completion(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No user logged in"]))
            return
        }
        
        let entry = [
            "habitID": habitID,
            "habitName": habitName,
            "value": value,
            "notes": notes,
            "date": Timestamp(date: Date())
        ] as [String : Any]
        
        db.collection("users")
            .document(uid)
            .collection("dailyEntries")
            .addDocument(data: entry, completion: completion)
    }
    func fetchLatestEntry(forHabitID habitID: String,
                          completion: @escaping (DailyEntry?) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else {
            completion(nil)
            return
        }
        
        let collection = db.collection("users")
            .document(uid)
            .collection("dailyEntries")
        
        // Get all entries for this habit, then pick the latest in code
        collection
            .whereField("habitID", isEqualTo: habitID)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error fetching latest entry:", error.localizedDescription)
                    completion(nil)
                    return
                }
                
                let docs = snapshot?.documents ?? []
                
                var latestEntry: DailyEntry? = nil
                
                for doc in docs {
                    let data = doc.data()
                    
                    guard
                        let habitName = data["habitName"] as? String,
                        let value = data["value"] as? String,
                        let notes = data["notes"] as? String,
                        let timestamp = data["date"] as? Timestamp
                    else { continue }
                    
                    let date = timestamp.dateValue()
                    let entry = DailyEntry(
                        id: doc.documentID,
                        habitID: habitID,
                        habitName: habitName,
                        value: value,
                        notes: notes,
                        date: date
                    )
                    
                    if let currentLatest = latestEntry {
                        if date > currentLatest.date {
                            latestEntry = entry
                        }
                    } else {
                        latestEntry = entry
                    }
                }
                
                completion(latestEntry)
            }
    }
}
