//
//  Action.swift
//  SBapp
//
//  Created by Max on 28/07/2023.
//

import UIKit

enum ActionType: String {
    case showFavorites = "showFavorites"
}

enum Action: Equatable {
    case showFavorites

    init?(shortcutItem: UIApplicationShortcutItem) {
        guard let type = ActionType(rawValue: shortcutItem.type) else {
            return nil
        }

        switch type {
        case .showFavorites:
            self = .showFavorites
        }
    }
}

class ActionService: ObservableObject {
    static let shared = ActionService()
    @Published var action: Action?
}
