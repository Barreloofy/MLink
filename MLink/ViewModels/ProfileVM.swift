//
//  ProfileVM.swift
//  MLink
//
//  Created by Barreloofy on 10/7/24 at 11:45 PM.
//

import Foundation
import SwiftUI
import PhotosUI

@MainActor
final class ProfileViewModel: ObservableObject {
    @Published var username = ""
    @Published var bioText = ""
    @Published var selectedItem: PhotosPickerItem?
    @Published var imageData: Data?
    @Published var showEditPage = false
    @Published var isLoading = false
    @Published var showAlert = false
    var errorMessage = ""
    var uid: String?
    
    func enforceLength(for property: inout String, maxLength: Int) {
        if property.count > maxLength {
            property = String(property.prefix(maxLength))
        }
    }
    
    func loadImage() {
        Task {
            if let data = try? await selectedItem?.loadTransferable(type: Data.self) {
                imageData = data
                return
            }
        }
    }
    
    func updateUser() {
        Task {
            isLoading = true
            do {
                guard let uid = uid else { throw CustomError.expectationError("User is nil.") }
                var imageUrl: String?
                if let imageData = imageData {
                    let path = "profileImages/\(UUID())"
                    imageUrl = try await StorageService.uploadImageData(imageData, to: path)
                }
                try await FirestoreService.updateUser(UserModel(uid, username, bioText, imageUrl))
                isLoading = false
            } catch {
                errorMessage = error.localizedDescription
                showAlert = true
                isLoading = false
            }
        }
    }
    
    func fetchUser() {
        Task {
            isLoading = true
            do {
                guard let uid = uid else { throw CustomError.expectationError("User is nil.") }
                let user = try await FirestoreService.fetchUser(for: uid)
                username = user.name
                bioText = user.biography ?? ""
                guard let url = user.profileImageUrl else { throw CustomError.expectationError("URL not found.") }
                imageData = try await StorageService.getImageData(for: url)
                isLoading = false
            } catch {
                errorMessage = error.localizedDescription
                showAlert = true
                isLoading = false
            }
        }
    }
}
