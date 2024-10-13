//
//  CommentModel.swift
//  MLink
//
//  Created by Barreloofy on 10/13/24 at 4:42 PM.
//

import Foundation

struct CommentModel: Codable, Identifiable {
    let id: String
    let authorId: String
    let author: String
    let timestamp: Date
    let content: String
    var likeCount = 0
    
    init(author: (id: String, name: String), content: String) {
        self.id = UUID().uuidString
        self.authorId = author.id
        self.author = author.name
        self.timestamp = Date()
        self.content = content
    }
    
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
}

extension CommentModel {
    static let testComment = CommentModel(author: (UUID().uuidString, "James"), content: "Phasellus fermentum malesuada phasellus netus dictum aenean placerat egestas amet.")
}
