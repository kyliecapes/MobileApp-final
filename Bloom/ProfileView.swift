//
//  ProfileView.swift
//  Bloom
//
//  Created by Kylie Capes on 11/25/25.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var authViewModel: AuthViewModel

    var body: some View {
        ZStack {
            BloomTheme.background.ignoresSafeArea()

            VStack(spacing: 24) {

                // Header
                VStack(spacing: 4) {
                    Text("Bloom 🌸")
                        .font(.system(size: 32, weight: .bold, design: .rounded))
                        .foregroundColor(BloomTheme.accentPink)

                    Text("Profile")
                        .font(.headline)
                        .foregroundColor(.black.opacity(0.8))
                }
                .padding(.top, 40)

                // User info card
                VStack(alignment: .leading, spacing: 12) {
                    Text("Signed in as")
                        .font(.subheadline)
                        .foregroundColor(.black.opacity(0.7))

                    Text(authViewModel.user?.email ?? "Unknown")
                        .font(.body)
                        .fontWeight(.semibold)

                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.white)
                .cornerRadius(16)
                .shadow(radius: 2, y: 2)
                .padding(.horizontal)

                // Logout button
                Button {
                    authViewModel.logOut()
                } label: {
                    Text("Sign Out")
                        .font(.system(size: 16, weight: .semibold))
                        .frame(maxWidth: .infinity)
                        .padding()
                }
                .background(Color.black)
                .foregroundColor(.white)
                .cornerRadius(12)
                .padding(.horizontal)

                Spacer()
            }
        }
    }
}
