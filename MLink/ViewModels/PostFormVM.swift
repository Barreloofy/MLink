//
//  PostFormVM.swift
//  MLink
//
//  Created by Barreloofy on 10/8/24 at 3:55 PM.
//

import Foundation
import SwiftUI
import PhotosUI

@MainActor
final class PostFormViewModel: ObservableObject {
    @Published var text = ""
    @Published var selectedItem: PhotosPickerItem?
    @Published var imageData: Data?
    @Published var indicatorColor = Color.gray
    @Published var showAlert = false
    var errorMessage = ""
    
    func enforceLength() {
        if text.count > 250 {
            text = String(text.prefix(250))
        }
    }
    
    func setIndicatorColor() {
        let textLength = text.count
        switch textLength {
            case 0..<83:
                return
            case 83..<167:
                indicatorColor = .yellow
            default:
                indicatorColor = .red
        }
    }
    
    func loadImage() {
        Task {
            guard selectedItem != nil else { return }
            if let data = try await selectedItem?.loadTransferable(type: Data.self) {
                imageData = data
            } else {
                errorMessage = "Failed to load image."
                showAlert = true
            }
        }
    }
    
    func createPost(user: UserModel?,_ action: ((ActionType) -> Void)?) {
        Task {
            do {
                guard let user = user else { throw CustomError.expectationError("User is nil.") }
                let uid = UUID().uuidString
                var url: String?
                if let imageData = imageData {
                    url = try await StorageService.uploadImageData(imageData, to: "postImages/\(uid)")
                }
                try await FirestoreService.createPost(PostModel(id: uid, author: (authorId: user.id, authorName: user.name), content: (text: text, imageUrl: url)))
                action?(ActionType.update)
            } catch {
                errorMessage = error.localizedDescription
                showAlert = true
            }
        }
    }
}
