//
//  FirestoreService.swift
//  MLink
//
//  Created by Barreloofy on 10/7/24 at 7:38 PM.
//

import FirebaseFirestore

struct FirestoreService {
    static let postsReference = Firestore.firestore().collection("Posts")
    static let usersReference = Firestore.firestore().collection("Users")
    
    // MARK: - Methods for the PostModel.
    static func createPost(_ post: PostModel) async throws {
        let document = postsReference.document(post.id)
        try await document.setData(from: post)
    }
    
    // MARK: - Methods for the UserModel.
    static func createUser(_ user: UserModel) async throws {
        let document = usersReference.document(user.id)
        try await document.setData(from: user)
    }
    
    static func updateUser(_ user: UserModel) async throws {
        var updateData: [String : Any] = ["name" : user.name]
        if let biography = user.biography {
            updateData["biography"] = biography
        }
        if let profileImageUrl = user.profileImageUrl {
            updateData["profileImageUrl"] = profileImageUrl
        }
        let document = usersReference.document(user.id)
        try await document.updateData(updateData)
    }
    
    static func fetchUser(for uid: String) async throws -> UserModel {
        let query = usersReference.document(uid)
        return try await query.getDocument(as: UserModel.self)
    }
}

extension DocumentReference {
    func setData<T: Encodable>(from value: T) async throws {
        return try await withCheckedThrowingContinuation { continuation in
            do {
                try setData(from: value)
                continuation.resume()
            } catch {
                continuation.resume(throwing: error)
            }
        }
    }
}
