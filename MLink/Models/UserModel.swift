//
//  UserModel.swift
//  MLink
//
//  Created by Barreloofy on 10/2/24 at 12:44 AM.
//

import Foundation

struct UserModel: Codable, Identifiable {
    var id: String
    var name: String
    var biography: String?
    var profileImageUrl: String?
    
    init(_ uid: String, _ username: String,_ biography: String? = nil,_ profileImageUrl: String? = nil) {
        self.id = uid
        self.name = username
        self.biography = biography
        self.profileImageUrl = profileImageUrl
    }
    
    init() {
        id = ""
        name = ""
    }
}
