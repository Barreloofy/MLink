//
//  AuthVM.swift
//  MLink
//
//  Created by Barreloofy on 10/2/24 at 8:19 PM.
//

import Foundation

@MainActor
final class AuthViewModel: ObservableObject {
    @Published var currentUser: UserModel?
}
