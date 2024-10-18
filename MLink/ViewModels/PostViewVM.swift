//
//  PostViewVM.swift
//  MLink
//
//  Created by Barreloofy on 10/16/24 at 3:55 PM.
//

import Foundation

@MainActor
final class PostViewViewModel: ObservableObject {
    @Published var isLiked = false
    @Published var showAlert = false
    
    func deletePost(for postId: String, action: ((ActionType) -> Void)?) {
        Task {
            do {
                try await FirestoreService.deletePost(for: postId)
                action?(ActionType.update)
            } catch {
                action?(ActionType.error(error.localizedDescription))
            }
        }
    }
    
    func fetchLikeStatus(post: PostModel, userId: String?, action: ((ActionType) -> Void)?) {
        Task {
            do {
                guard let userId = userId else { throw CustomError.expectationError("User is nil.") }
                isLiked = try await FirestoreService.fetchLikeStatus(userId: userId, postId: post.id, commentId: nil)
            } catch {
                action?(ActionType.error(error.localizedDescription))
            }
        }
    }
    
    func likeAction(post: PostModel, userId: String?, action: ((ActionType) -> Void)?) {
        Task {
            do {
                guard let userId = userId else { throw CustomError.expectationError("User is nil.") }
                if isLiked {
                    try await FirestoreService.unlikeItem(userId: userId, postId: post.id, commentId: nil)
                    try await FirestoreService.updatePost(for: post.id, with: post.likeCount - 1)
                    isLiked = false
                } else {
                    try await FirestoreService.likeItem(userId: userId, postId: post.id, commentId: nil)
                    try await FirestoreService.updatePost(for: post.id, with: post.likeCount + 1)
                    isLiked = true
                }
                action?(ActionType.update)
            } catch {
                action?(ActionType.error(error.localizedDescription))
            }
        }
    }
}
