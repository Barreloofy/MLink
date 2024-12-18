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
    @Published var userPosts = [PostModel]()
    @Published var username = ""
    @Published var bioText = ""
    @Published var selectedItem: PhotosPickerItem?
    @Published var imageData: Data?
    @Published var showEditPage = false
    @Published var isLoading = false
    @Published var showAlert = false { didSet { errorMessage = showAlert ? errorMessage : "" } }
    var errorMessage = ""
    private var uid = ""
    
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
    
    private func fetchUser(_ userId: String) throws {
        Task {
            let user = try await FirestoreService.fetchUser(for: userId)
            username = user.name
            bioText = user.biography ?? ""
            guard let imageUrl = user.profileImageUrl else { return }
            imageData = try await StorageService.getImageData(for: imageUrl)
        }
    }
    
    private func fetchUserPosts(_ userId: String) throws {
        Task {
            userPosts = try await FirestoreService.fetchUserPosts(for: userId)
        }
    }
    
    private func updateUser(_ userId: String) throws {
        Task {
            var imageUrl: String?
            if let imageData = imageData {
                let path = "profileImages/\(UUID())"
                imageUrl = try await StorageService.uploadImageData(imageData, to: path)
            }
            try await FirestoreService.updateUser(UserModel(userId, username, bioText, imageUrl))
        }
    }
    
    func actionProcess(_ action: ActionType) {
        switch action {
            case .update:
            try? fetchUserPosts(uid)
            case .error(let message):
            errorMessage = message
            showAlert = true
            @unknown default:
            break
        }
    }
    // MARK: - convenience methods.
    
    func LoadingTime() {
        Task {
            try? await Task.sleep(nanoseconds: 1_000_000_000 / 2)
            isLoading = false
        }
    }
    
    func loadData(for userId: String?) {
        do {
            isLoading = true
            guard let userId = userId else { throw CustomError.expectationError() }
            uid = userId
            try fetchUser(userId)
            try fetchUserPosts(userId)
        } catch {
            errorMessage = error.localizedDescription
            showAlert = true
            isLoading = false
        }
    }
}
