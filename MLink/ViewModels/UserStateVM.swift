//
//  UserStateVM.swift
//  MLink
//
//  Created by Barreloofy on 10/7/24 at 10:41 PM.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

@MainActor
final class UserStateViewModel: ObservableObject {
    @Published var currentUser: UserModel?
    
    private var authListener: AuthStateDidChangeListenerHandle?
    private var userDataListener: ListenerRegistration?
    
    func signOut() {
        try? AuthService.signOut()
        removeUserDataListener()
        currentUser = nil
    }
    
    func registerListener(for uid: String) {
        userDataListener?.remove()
        let query = Firestore.firestore().collection("Users").document(uid)
        userDataListener = query.addSnapshotListener { [weak self] snapshot, error in
            guard error == nil else { self?.currentUser = nil; self?.removeUserDataListener(); return }
            guard let user = try? snapshot?.data(as: UserModel.self) else { return }
            self?.currentUser = user
        }
    }
    
    func removeUserDataListener() {
        userDataListener?.remove()
    }
    
    func removeAuthListener() {
        guard let authListener = authListener else { return }
        Auth.auth().removeStateDidChangeListener(authListener)
    }
    
    init() {
        authListener = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            guard let user = user else { self?.currentUser = nil; return }
            self?.registerListener(for: user.uid)
        }
    }
    
    deinit {
        Task { [weak self] in
            await self?.removeAuthListener()
            await self?.removeUserDataListener()
        }
    }
}
