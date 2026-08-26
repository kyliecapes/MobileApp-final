//
//  Models.swift
//  Bloom
//
//  Created by Kylie Capes on 11/24/25.
//

import Foundation

struct Habit: Identifiable {
    let id: String
    var name: String
    var isCompletedToday: Bool
}

struct AITip: Identifiable, Codable {
    var id: String
    var title: String
    var goal: String
    var suggestion: String
    var createdAt: Date
}

struct DailyEntry: Identifiable {
    let id: String
    let habitID: String
    let habitName: String
    let value: String
    let notes: String
    let date: Date
}


