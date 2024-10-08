//
//  PostModel.swift
//  MLink
//
//  Created by Barreloofy on 10/6/24 at 5:13 PM.
//

import Foundation

struct PostModel: Codable, Hashable, Identifiable {
    var id: String
    var authorId: String
    var author: String
    var timestamp = Date()
    var text: String
    var imageUrl: String?
    
    init(
        id: String,
        author: (authorId: String, authorName: String),
        content: (text: String, imageUrl: String?)
    ) {
        self.id = id
        self.authorId = author.authorId
        self.author = author.authorName
        self.text = content.text
        self.imageUrl = content.imageUrl
    }
}
