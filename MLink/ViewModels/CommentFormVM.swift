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
    
    func createComment(user: UserModel?, postId: String, action: ((ActionModel) -> Void)?) {
        Task {
            do {
                guard let user = user else { throw CustomError.expectationError("User is nil.")}
                try await FirestoreService.createComment(CommentModel(author: (id: user.id, name: user.name), content: text), postId: postId)
                text = ""
                action?(ActionModel(type: .update, content: ""))
            } catch {
                action?(ActionModel(type: .error, content: error.localizedDescription))
            }
        }
    }
}
