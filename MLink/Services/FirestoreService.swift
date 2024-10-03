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
}

extension DocumentReference {
    func setData<T: Encodable>(from value: T) async throws {
        return try await withCheckedThrowingContinuation { continuation in
            try! setData(from: value) { error in
                if let error = error {
                    continuation.resume(throwing: error)
                }
                continuation.resume()
            }
        }
    }
}
