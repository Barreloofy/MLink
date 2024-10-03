//
//  AuthService.swift
//  MLink
//
//  Created by Barreloofy on 10/2/24 at 7:32 PM.
//

import Foundation
import FirebaseAuth

struct AuthService {
    let firestoreService = FirestoreService()
    
    func signUp(with username: String, for email: String, with password: String) async throws -> UserModel {
        let result = try await Auth.auth().createUser(withEmail: email, password: password)
        try await firestoreService.createUser(from: result.user.uid, with: username)
        return try await firestoreService.fetchUser(from: result.user.uid)
    }
    
    func signIn(for email: String, with password: String) async throws -> UserModel {
        let result = try await Auth.auth().signIn(withEmail: email, password: password)
        return try await firestoreService.fetchUser(from: result.user.uid)
    }
}
