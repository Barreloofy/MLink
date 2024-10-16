//
//  SettingsVM.swift
//  MLink
//
//  Created by Barreloofy on 10/16/24 at 11:27 PM.
//

import Foundation
import FirebaseAuth

@MainActor
final class SettingsViewModel: ObservableObject {
    @Published private var showAlert = false
    @Published private var showErrorAlert = false
    var errorMessage = ""
    
    func deleteAccount() {
        Task {
            do {
                try await Auth.auth().currentUser?.delete()
            } catch {
                errorMessage = error.localizedDescription
                showErrorAlert = true
            }
        }
    }
}
