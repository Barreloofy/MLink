//
//  AuthVM.swift
//  MLink
//
//  Created by Barreloofy on 10/7/24 at 7:09 PM.
//

import Foundation
import FirebaseAuth

@MainActor
final class AuthenticationViewModel: ObservableObject {
    @Published var username = ""
    @Published var email = ""
    @Published var password = ""
    @Published var isLoading = false
    @Published var showAlert = false
    var errorMessage = ""
    
    func signUp() {
        isLoading = true
        Task {
            do {
                try await AuthService.signUp(username: username, email: email, password: password)
                isLoading = false
            } catch {
                errorMessage = error.localizedDescription
                showAlert = true
                isLoading = false
            }
        }
    }
    
    func signIn() {
        isLoading = true
        Task {
            do {
                try await AuthService.signIn(email: email, password: password)
                isLoading = false
            } catch {
                errorMessage = error.localizedDescription
                showAlert = true
                isLoading = false
            }
        }
    }
}
