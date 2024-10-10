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
    
    static func fetchPosts() async throws -> [PostModel] {
        let documents = try await postsReference.getAllDocuments().documents
        return try documents.map { try $0.data(as: PostModel.self) }
    }
    
    static func fetchPosts(for userId: String) async throws -> [PostModel] {
        let query = postsReference.whereField("authorId", isEqualTo: userId)
        let documents = try await query.getAllDocuments().documents
        return try documents.map { try $0.data(as: PostModel.self)}
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

extension Query {
    func getAllDocuments() async throws -> QuerySnapshot {
        return try await withCheckedThrowingContinuation { continuation in
            getDocuments { querySnapshot, error in
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }
                guard let querySnapshot = querySnapshot else {
                    continuation.resume(throwing: CustomError.expectationError("Unexpectedly found nil while unwrapping an Optional value"))
                    return
                }
                continuation.resume(returning: querySnapshot)
            }
        }
    }
}
