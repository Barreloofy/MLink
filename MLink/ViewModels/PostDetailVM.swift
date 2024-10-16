//
//  PostDetailVM.swift
//  MLink
//
//  Created by Barreloofy on 10/14/24 at 9:01 PM.
//

import Foundation

@MainActor
final class PostDetailViewModel: ObservableObject {
    @Published var comments = [CommentModel]()
    @Published var showAlert = false
    var errorMessage = ""
    
    func actionProcess(action: ActionType, postId: String) {
        switch action {
            case .error(let message):
            errorMessage = message
            showAlert = true
            case .update:
            fetchComments(for: postId)
            @unknown default:
            break
        }
    }
    
    // MARK: - Wrapped FirestoreService methods.
    
    func fetchComments(for postId: String) {
        Task {
            do {
                comments = try await FirestoreService.fetchComments(for: postId)
            } catch {
                errorMessage = error.localizedDescription
                showAlert = true
            }
        }
    }
}
