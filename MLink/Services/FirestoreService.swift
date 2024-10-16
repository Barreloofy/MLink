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
        let query = postsReference.order(by: "timestamp", descending: true).limit(to: 100)
        let documents = try await query.getAllDocuments().documents
        return try documents.map { try $0.data(as: PostModel.self) }
    }
    
    // Not used because of memory leaks in Firestore SDK.
    static func fetchPosts(for userId: String) async throws -> [PostModel] {
        let query = postsReference.whereField("authorId", isEqualTo: userId)
        let documents = try await query.getAllDocuments().documents
        return try documents.map { try $0.data(as: PostModel.self) }
    }
    
    // Workaround, less efficient and not as capable.
    static func fetchUserPosts(for userId: String) async throws -> [PostModel] {
        let query = postsReference.order(by: "timestamp", descending: true).limit(to: 100)
        let documents = try await query.getAllDocuments().documents
        let posts = try documents.map { try $0.data(as: PostModel.self) }
        return posts.filter { $0.authorId == userId }
    }
    
    static func updatePost(for postId: String, with newValue: Int) async throws {
        let query = postsReference.document(postId)
        try await query.updateDataAsync(["likeCount" : newValue])
    }
    
    static func deletePost(for postId: String) async throws {
        let query = postsReference.document(postId)
        try await query.deleteDocument()
    }
    
    // MARK: -- Methods for the Like feature.
    
    static func queryBuilder(userId: String, postId: String, commentId: String?) -> DocumentReference {
        if let commentId = commentId {
            return postsReference.document(postId).collection("Comments").document(commentId).collection("Likes").document(userId)
        } else {
            return postsReference.document(postId).collection("Likes").document(userId)
        }
    }
    
    static func fetchLikeStatus(userId: String, postId: String, commentId: String?) async throws -> Bool {
        let query = queryBuilder(userId: userId, postId: postId, commentId: commentId)
        return try await query.getOneDocument().exists
    }
    
    static func likePost(userId: String, postId: String, commentId: String?) async throws {
        let document = queryBuilder(userId: userId, postId: postId, commentId: commentId)
        try await document.setDataAsync([:])
    }
    
    static func unlikePost(userId: String, postId: String, commentId: String?) async throws {
        let query = queryBuilder(userId: userId, postId: postId, commentId: commentId)
        try await query.deleteDocument()
    }
    
    // MARK: - Methods for the CommentModel.
    
    static func createComment(_ comment: CommentModel) async throws {
        let document = postsReference.document(comment.postId).collection("Comments").document(comment.id)
        try await document.setData(from: comment)
    }
    
    static func fetchComments(for postId: String) async throws -> [CommentModel] {
        let query = postsReference.document(postId).collection("Comments").order(by: "timestamp", descending: true)
        let documents = try await query.getAllDocuments().documents
        return try documents.map { try $0.data(as: CommentModel.self) }
    }
    
    static func deleteComment(commentId: String, postId: String) async throws {
        let query = postsReference.document(postId).collection("Comments").document(commentId)
        try await query.deleteDocument()
    }
    
    static func updateComment(commentId: String, postId: String, with newValue: Int) async throws {
        let query = postsReference.document(postId).collection("Comments").document(commentId)
        try await query.updateDataAsync(["likeCount" : newValue])
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
        try await document.updateDataAsync(updateData)
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
    
    func setDataAsync(_ documentData: [String : Any]) async throws {
        return try await withCheckedThrowingContinuation { continuation in
            setData(documentData) { error in
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }
                continuation.resume()
            }
        }
    }
    
    func updateDataAsync(_ fields: [AnyHashable : Any]) async throws {
        return try await withCheckedThrowingContinuation { continuation in
            updateData(fields) { error in
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }
                continuation.resume()
            }
        }
    }
    
    func deleteDocument() async throws {
        return try await withCheckedThrowingContinuation { continuation in
            delete { error in
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }
                continuation.resume()
            }
        }
    }
    
    func getOneDocument() async throws -> DocumentSnapshot {
        return try await withCheckedThrowingContinuation { continuation in
            getDocument { snapshot, error in
                guard let snapshot, error == nil else {
                    continuation.resume(throwing: error!)
                    return
                }
                continuation.resume(returning: snapshot)
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
