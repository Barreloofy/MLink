//
//  ActionModel.swift
//  MLink
//
//  Created by Barreloofy on 10/12/24 at 6:37 PM.
//

import Foundation

struct ActionModel {
    let actionType: ActionType
    let forItem: String
    let fromUser: String
    var DEBUGMessage: String {
        String("\(actionType) requested by user: \(fromUser) for item: \(forItem)")
    }
    
    enum ActionType {
        case delete
        case favorite
        case unFavorite
    }
}
