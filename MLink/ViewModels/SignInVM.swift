//
//  SignInVM.swift
//  MLink
//
//  Created by Barreloofy on 10/2/24 at 1:28 AM.
//

import Foundation

@MainActor
final class SignInViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var isLoading = false
    @Published var showAlert = false
    var errorMessage = ""
    
    private let authService = AuthService()
    private let authViewModel: AuthViewModel
    
    func signIn() {
        isLoading.toggle()
        Task {
            do {
                let user = try await authService.signIn(for: email, with: password)
                authViewModel.currentUser = user
                isLoading.toggle()
            } catch {
                errorMessage = error.localizedDescription
                isLoading.toggle()
                showAlert.toggle()
            }
        }
    }
    
    init(authViewModel: AuthViewModel) {
        self.authViewModel = authViewModel
    }
}
