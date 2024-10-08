//
//  AuthService.swift
//  MLink
//
//  Created by Barreloofy on 10/7/24 at 8:49 PM.
//

import FirebaseAuth

struct AuthService {
    static func signUp(username: String, email: String, password: String) async throws {
        let result = try await Auth.auth().createUser(withEmail: email, password: password)
        try await FirestoreService.createUser(UserModel(result.user.uid, username))
    }
    
    static func signIn(email: String, password: String) async throws {
        try await Auth.auth().signIn(withEmail: email, password: password)
    }
    
    static func signOut() throws {
        try Auth.auth().signOut()
    }
}
