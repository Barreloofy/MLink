//
//  PostViewVM.swift
//  MLink
//
//  Created by Barreloofy on 10/13/24 at 2:13 PM.
//

import Foundation
import SwiftUI

@MainActor
final class PostViewViewModel: ObservableObject {
    var isLiked = false
    @Published var post: PostModel
    
    init(post: PostModel) {
        self.post = post
    }
    
    func loadImage(from urlString: String?) -> some View {
        guard let urlString = urlString, let imageUrl = URL(string: urlString) else {
            return AnyView(EmptyView())
        }
        return AnyView(AsyncImage(url: imageUrl) { image in
            image
                .resizable()
                .scaledToFit()
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .shadow(radius: 10)
                .padding()
        } placeholder: {
            EmptyView()
        })
    }
    
    func fetchLikeStatus(userId: String?, postId: String) {
        guard let uid = userId else { return }
        Task {
            do {
                isLiked = try await FirestoreService.fetchLikeStatus(userId: uid, postId: postId)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func likeAction(userId: String?) {
        guard let uid = userId else { return }
        Task {
            do {
                if !isLiked {
                    isLiked = true
                    post.likeCount += 1
                    try await FirestoreService.likePost(userId: uid, postId: post.id)
                    try await FirestoreService.updatePost(for: post.id, with: post.likeCount)
                } else {
                    isLiked = false
                    post.likeCount -= 1
                    try await FirestoreService.unLikePost(userId: uid, postId: post.id)
                    try await FirestoreService.updatePost(for: post.id, with: post.likeCount)
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
