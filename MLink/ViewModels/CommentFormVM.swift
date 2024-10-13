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
    
    func createComment(user: UserModel?, postId: String) {
        Task {
            do {
                guard let user = user else { throw CustomError.expectationError("User is nil.")}
                try await FirestoreService.createComment(CommentModel(author: (id: user.id, name: user.name), content: text), postId: postId)
                text = ""
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
