//
//  ActionModel.swift
//  MLink
//
//  Created by Barreloofy on 10/14/24 at 10:34 PM.
//

import Foundation

struct ActionModel {
    enum ActionType {
        case error
        case update
    }
    
    let type: ActionType
    let content: String
}
