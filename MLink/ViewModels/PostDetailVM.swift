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
    
    func actionProcess(action: ActionModel, postId: String) {
        switch action.type {
            case .error:
            errorMessage = action.content
            showAlert = true
            case .update:
            fetchComments(for: postId)
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
