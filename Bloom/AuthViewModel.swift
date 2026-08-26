//
//  AuthViewModel.swift
//  Bloom
//
//  Created by Kylie Capes on 11/24/25.
//

import Foundation
import FirebaseAuth
import Combine

class AuthViewModel: ObservableObject {
    @Published var user: User? = nil
    @Published var authError: String? = nil
    @Published var isLoading: Bool = false
    
    private var authStateHandle: AuthStateDidChangeListenerHandle?
    
    init() {
        listenToAuthChanges()
    }
    
    var isAuthenticated: Bool {
        user != nil
    }
    
    private func listenToAuthChanges() {
        authStateHandle = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            self?.user = user
        }
    }
    
    deinit {
        if let handle = authStateHandle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }
    
    // MARK: - Actions
    
    func signUp(email: String, password: String) {
        authError = nil
        isLoading = true
        
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
            DispatchQueue.main.async {
                self?.isLoading = false
                if let error = error {
                    self?.authError = error.localizedDescription
                } else {
                    self?.user = result?.user
                }
            }
        }
    }
    
    func logIn(email: String, password: String) {
        authError = nil
        isLoading = true
        
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in
            DispatchQueue.main.async {
                self?.isLoading = false
                if let error = error {
                    self?.authError = error.localizedDescription
                } else {
                    self?.user = result?.user
                }
            }
        }
    }
    
    func logOut() {
        do {
            try Auth.auth().signOut()
            user = nil
        } catch {
            authError = error.localizedDescription
        }
    }
}
