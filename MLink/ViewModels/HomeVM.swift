//
//  HomeVM.swift
//  MLink
//
//  Created by Barreloofy on 10/10/24 at 8:43 PM.
//

import Foundation

@MainActor
final class HomeViewModel: ObservableObject {
    @Published var posts = [PostModel]()
    @Published var showSheet = false
    @Published var isLoading = true
    @Published var showAlert = false
    var errorMessage = ""
    
    private func fetchPosts() {
        Task {
            do {
                posts = try await FirestoreService.fetchPosts()
            } catch {
                errorMessage = error.localizedDescription
                showAlert = true
            }
        }
    }
    
    func actionProcess(_ action: ActionType) {
        switch action {
            case .error(let message):
            errorMessage = message
            showAlert = true
            case .update:
            fetchPosts()
            showSheet = false
            @unknown default:
            break
        }
    }
    // MARK: - convenience methods.
    
    func fetchPostsOnAppear() {
        Task {
            fetchPosts()
            try await Task.sleep(nanoseconds: 1_000_000_000)
            isLoading = false
        }
    }
    
    func refreshPosts() {
        fetchPosts()
    }
}
