//
//  TabScene.swift
//  MLink
//
//  Created by Barreloofy on 10/3/24 at 10:07 PM.
//

import SwiftUI

struct TabScene: View {
    
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
        .tint(Color(red: 255 / 255, green: 69 / 255, blue: 0 / 255))
    }
}

#Preview {
    TabScene()
}
