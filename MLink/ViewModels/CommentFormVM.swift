//
//  CommentFormVM.swift
//  MLink
//
//  Created by Barreloofy on 10/14/24 at 12:22 AM.
//

import Foundation

@MainActor
final class CommentFormViewModel: ObservableObject {
    @Published var text = ""
    
    func EnforceLength() {
        if text.count > 125 {
            text = String(text.prefix(125))
        }
    }
    
    func createComment(user: UserModel?, postId: String, action: ((ActionType) -> Void)?) {
        Task {
            do {
                guard let user = user else { throw CustomError.expectationError("User is nil.")}
                try await FirestoreService.createComment(CommentModel(postId: postId, author: (id: user.id, name: user.name), content: text))
                text = ""
                action?(ActionType.update)
            } catch {
                action?(ActionType.error(error.localizedDescription))
            }
        }
    }
}
