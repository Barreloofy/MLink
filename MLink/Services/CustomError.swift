//
//  CustomError.swift
//  MLink
//
//  Created by Barreloofy on 10/6/24 at 9:20 PM.
//

import Foundation

enum CustomError: Error, LocalizedError {
    case expectationError(String = "User is nil.")
    
    var errorDescription: String? {
        switch self {
            case .expectationError(let message):
                return message
        }
    }
}
