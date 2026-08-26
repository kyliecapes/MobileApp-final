//
//  MainTabView.swift
//  Bloom
//
//  Created by Kylie Capes on 11/24/25.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            NavigationStack {
                TrackerView()
            }
            .tabItem {
                Image(systemName: "checklist")
                Text("Tracker")
            }

            NavigationStack {
                DashboardView()
            }
            .tabItem {
                Image(systemName: "chart.bar")
                Text("Dashboard")
            }

            NavigationStack {
                GoalEntryView()
            }
            .tabItem {
                Image(systemName: "plus.circle")
                Text("Entry")
            }

            NavigationStack {
                AITipsListView()
            }
            .tabItem {
                Image(systemName: "sparkles")
                Text("AI Tips")
            }

            NavigationStack {
                ProfileView()
            }
            .tabItem {
                Image(systemName: "person.circle")
                Text("Profile")
            }
        }
    }
}
