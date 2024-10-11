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
    var uid: String?
    private var userWasFetched = false
    
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
            guard !userWasFetched else { return }
            do {
                guard let uid = uid else { throw CustomError.expectationError("User is nil.") }
                let user = try await FirestoreService.fetchUser(for: uid)
                username = user.name
                bioText = user.biography ?? ""
                guard let url = user.profileImageUrl else { throw CustomError.expectationError("URL not found.") }
                imageData = try await StorageService.getImageData(for: url)
                userWasFetched = true
            } catch {
                errorMessage = error.localizedDescription
                showAlert = true
                isLoading = false
            }
        }
    }
    
    func fetchUserPosts() {
        Task {
            guard userPosts.isEmpty else { return }
            do {
                guard let uid = uid else { throw CustomError.expectationError("User is nil.") }
                userPosts = try await FirestoreService.fetchUserPosts(for: uid)
                //userPosts = try await FirestoreService.fetchPosts(for: uid)
            } catch {
                errorMessage = error.localizedDescription
                showAlert = true
                isLoading = false
            }
        }
    }
    
    // MARK: - Convenience method.
    func saveEdit() {
        isLoading = true
        updateUser()
        fetchUser()
        if errorMessage.isEmpty {
            showEditPage.toggle()
        }
        isLoading = false
    }
    
    func onAppear() {
        isLoading = true
        fetchUser()
        fetchUserPosts()
        isLoading = false
    }
}
