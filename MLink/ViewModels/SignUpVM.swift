//
//  SignUpVM.swift
//  MLink
//
//  Created by Barreloofy on 10/2/24 at 1:42 AM.
//

import Foundation

@MainActor
final class SignUpViewModel: ObservableObject {
    @Published var username = ""
    @Published var email = ""
    @Published var password = ""
    @Published var isLoading = false
    @Published var showAlert = false
    var errorMessage = ""
    
    private let authService = AuthService()
    private let authViewModel: AuthViewModel
    
    func signUp() {
        isLoading.toggle()
        Task {
            do {
                let user = try await authService.signUp(with: username, for: email, with: password)
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
