//
//  TabScene.swift
//  MLink
//
//  Created by Barreloofy on 10/3/24 at 10:07 PM.
//

import SwiftUI

struct TabScene: View {
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        TabView {
            Tab("", systemImage: "house") {
                HomeView()
            }
            Tab("", systemImage: "person.circle") {
                ProfileView()
            }
            Tab("", systemImage: "gear") {
                SettingsView()
            }
        }
        .tint(colorScheme == .light ? .black : .white)
    }
}

#Preview {
    TabScene()
}
