//
//  FirestoreService.swift
//  MLink
//
//  Created by Barreloofy on 10/3/24 at 12:40 AM.
//

import Foundation
import FirebaseFirestore

struct FirestoreService {
    private let db = Firestore.firestore().collection("Users")
    
    func createUser(from uid: String, with username: String) async throws  {
        let query = db.document(uid)
        try await query.setData(from: UserModel(uid, username))
    }
    
    func fetchUser(from uid: String) async throws -> UserModel {
        let query = db.document(uid)
        let user = try await query.getDocument(as: UserModel.self)
        return user
    }
    
    func updateUser(from uid: String, for user: (username: String?, biography: String?, imageUrl: URL?)) async throws {
        guard let username = user.username, let biography = user.biography, let imageUrl = user.imageUrl else {
                throw NSError(domain: "Invalid input", code: 400, userInfo: [NSLocalizedDescriptionKey: "User details must not be nil"])
            }
        let query = db.document(uid)
        try await query.updateData(["username" : username, "biography" : biography, "profileImageUrl" : imageUrl.absoluteString])
    }
}

extension DocumentReference {
    func setData<T: Encodable>(from value: T) async throws {
        return try await withCheckedThrowingContinuation { [weak self] continuation in
            do {
                try self?.setData(from: value) { error in
                    if let error = error {
                        continuation.resume(throwing: error)
                    } else {
                        continuation.resume()
                    }
                }
            } catch {
                continuation.resume(throwing: error)
            }
        }
    }
}
