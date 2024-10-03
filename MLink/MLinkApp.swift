//
//  MLinkApp.swift
//  MLink
//
//  Created by Barreloofy on 10/2/24 at 12:27 AM.
//

import SwiftUI
import FirebaseCore

@main
struct MLinkApp: App {
    init() {
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            AuthenticationView()
        }
    }
}
