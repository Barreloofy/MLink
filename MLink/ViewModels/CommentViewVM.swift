//
//  CommentViewVM.swift
//  MLink
//
//  Created by Barreloofy on 10/15/24 at 10:44 PM.
//

import Foundation

@MainActor
final class CommentViewViewModel: ObservableObject {
    @Published var isLiked = false
    @Published var showAlert = false
    
    func deleteComment(for comment: CommentModel, action: ((ActionType) -> Void)?) {
        Task {
            do {
                try await FirestoreService.deleteComment(commentId: comment.id, postId: comment.postId)
                action?(ActionType.update)
            } catch {
                action?(ActionType.error(error.localizedDescription))
            }
        }
    }
    
    func fetchIsLiked(comment: CommentModel, userId: String?, action: ((ActionType) -> Void)?) {
        Task {
            do {
                guard let userId = userId else { throw CustomError.expectationError("User is nil.") }
                isLiked = try await FirestoreService.fetchLikeStatus(userId: userId, postId: comment.postId, commentId: comment.id)
            } catch {
                action?(ActionType.error(error.localizedDescription))
            }
        }
    }
    
    func likeAction(comment: CommentModel, userId: String?, action: ((ActionType) -> Void)?) {
        Task {
            do {
                guard let userId = userId else { throw CustomError.expectationError("User is nil.") }
                if isLiked {
                    try await FirestoreService.unlikePost(userId: userId, postId: comment.postId, commentId: comment.id)
                    try await FirestoreService.updateComment(commentId: comment.id, postId: comment.postId, with: comment.likeCount - 1)
                    isLiked = false
                } else {
                    try await FirestoreService.likePost(userId: userId, postId: comment.postId, commentId: comment.id)
                    try await FirestoreService.updateComment(commentId: comment.id, postId: comment.postId, with: comment.likeCount + 1)
                    isLiked = true
                }
                action?(.update)
            } catch {
                action?(ActionType.error(error.localizedDescription))
            }
        }
    }
}
