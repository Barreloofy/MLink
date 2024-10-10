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
    
    func timestampFormatter() -> String {
        let currentDate = Date()
        let timeInterval = (currentDate.timeIntervalSince(timestamp) / 3600)
        let dateFormatter = DateFormatter()
        
        switch timeInterval {
            case 0..<24:
            dateFormatter.dateFormat = "h:mm a"
            case 24..<168:
            dateFormatter.dateFormat = "EEEE"
            default:
            dateFormatter.dateFormat = "dd/MM/yy"
        }
        return dateFormatter.string(from: timestamp)
    }
    
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

#if DEBUG
extension PostModel {
    static let testPost = PostModel(
        id: UUID().uuidString,
        author: (authorId: UUID().uuidString, authorName: "James"),
        content: (text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.", imageUrl: nil))
}
#endif
