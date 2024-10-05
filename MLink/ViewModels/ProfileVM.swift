//
//  ProfileVM.swift
//  MLink
//
//  Created by Barreloofy on 10/4/24 at 3:11 PM.
//

import Foundation
import SwiftUI
import PhotosUI

@MainActor
final class ProfileViewModel: ObservableObject {
    @Published var username: String
    @Published var bioText: String
    @Published var image: UIImage?
    @Published var imageSelection: PhotosPickerItem? {
        didSet {
            Task {
                guard let data = try? await imageSelection?.loadTransferable(type: Data.self) else { return }
                image = UIImage(data: data)
            }
        }
    }
    @Published var showAlert = false
    @Published var isLoading = false
    @Published var showEditPage = false
    var errorMessage = ""
    private let firestoreService = FirestoreService()
    private weak var authViewModel: AuthViewModel?
    
    private enum CustomError: Error, LocalizedError {
        case expectationError(String)
    }
    
    func updateUser() {
        guard !username.isEmpty, bioText.count <= 100 else {
            errorMessage = "Username can't be empty, your Bio can't be more then 100 characters long"
            showAlert.toggle()
            return
        }
        isLoading.toggle()
        Task { [weak self] in
            let storageService = StorageService()
            do {
                guard let data = self?.image?.jpegData(compressionQuality: 0.70) else {
                    throw CustomError.expectationError("Encoding Error.")
                }
                let imageUrl = try await storageService.uploadImage(data: data, to: "images/\(UUID())")
                guard let uid = self?.authViewModel?.currentUser?.id else {
                    throw CustomError.expectationError("No user could be found.")
                }
                try await self?.firestoreService.updateUser(from: uid, for: (username: self?.username, biography: self?.bioText, imageUrl: imageUrl))
                self?.isLoading.toggle()
            } catch {
                self?.errorMessage = error.localizedDescription
                self?.isLoading.toggle()
                self?.showAlert.toggle()
            }
        }
    }
    
    func getImage() {
        guard self.image == nil else { return }
        isLoading.toggle()
        Task { [weak self] in
            do {
                guard let url = self?.authViewModel?.currentUser?.profileImageUrl else {
                    self?.image = nil
                    self?.isLoading.toggle()
                    return
                }
                let data = try await StorageService.getData(from: url)
                self?.image = UIImage(data: data)
                self?.isLoading.toggle()
            } catch {
                self?.errorMessage = error.localizedDescription
                self?.isLoading.toggle()
                self?.showAlert.toggle()
            }
        }
    }
    
    init(authViewModel: AuthViewModel) {
        self.authViewModel = authViewModel
        self.username = authViewModel.currentUser?.name ?? ""
        self.bioText = authViewModel.currentUser?.biography ?? ""
    }
}
