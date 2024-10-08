//
//  StorageService.swift
//  MLink
//
//  Created by Barreloofy on 10/8/24 at 1:44 AM.
//

import FirebaseStorage
import Foundation

struct StorageService {
    static func uploadImageData(_ data: Data, to path: String) async throws -> String {
        let reference = Storage.storage().reference().child(path)
        _ = try await reference.putDataAsync(data)
        return try await reference.downloadURL().absoluteString
    }
    
    static func getImageData(for url: String) async throws -> Data {
        let query = Storage.storage().reference(forURL: url)
        return try await query.getData(maxSize: 10 * 1024 * 1024)
    }
}

extension StorageReference {
    func getData(maxSize: Int64) async throws -> Data {
        return try await withCheckedThrowingContinuation { continuation in
            getData(maxSize: maxSize) { result in
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
