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
    @Published var isLoading = false
    @Published var showAlert = false
    var errorMessage = ""
    
    func fetchAllPosts(refreshable: Bool) {
        if posts.isEmpty || refreshable {
            Task {
                if !refreshable { isLoading = true }
                do {
                    posts = try await FirestoreService.fetchPosts()
                    try await Task.sleep(nanoseconds: 1_000_000_000 / 2)
                    isLoading = false
                } catch {
                    errorMessage = error.localizedDescription
                    showAlert = true
                    isLoading = false
                }
            }
        }
    }
    
    func deletePost(for uid: String, at index: Int) {
        Task {
            do {
                try await FirestoreService.deletePost(for: uid)
                posts.remove(at: index)
            } catch {
                errorMessage = error.localizedDescription
                showAlert = true
            }
        }
    }
}
