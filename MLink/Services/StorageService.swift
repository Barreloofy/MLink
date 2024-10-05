//
//  StorageService.swift
//  MLink
//
//  Created by Barreloofy on 10/5/24 at 12:37 PM.
//

import Foundation
import FirebaseStorage

struct StorageService {
    private let storage = Storage.storage().reference()
    
    private func imageReference(for path: String) -> StorageReference {
        return storage.child(path)
    }
    
    private func putData(data: Data, to path: String) async throws -> StorageReference {
        let reference = imageReference(for: path)
        _ = try await reference.putDataAsync(data)
        return reference
    }
    
    private func getdownloadUrl(storageRef: StorageReference) async throws -> URL {
        return try await storageRef.downloadURL()
    }
    
    func uploadImage(data: Data, to path: String) async throws -> URL {
        let reference = try await putData(data: data, to: path)
        return try await getdownloadUrl(storageRef: reference)
    }
    
    static func getData(from url: URL) async throws -> Data {
        let ref = try Storage.storage().reference(for: url)
        return try await ref.getData(maxSize: 10 * 1024 * 1024)
    }
    
}

extension StorageReference {
    func getData(maxSize: Int64) async throws -> Data {
        return try await withCheckedThrowingContinuation { [weak self] continuation in
            self?.getData(maxSize: maxSize) { result in
                switch result {
                    case .success(let data):
                        continuation.resume(returning: data)
                    case .failure(let error):
                        continuation.resume(throwing: error)
                }
            }
        }
    }
}
