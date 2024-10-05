//
//  TabScene.swift
//  MLink
//
//  Created by Barreloofy on 10/3/24 at 10:07 PM.
//

import SwiftUI

struct TabScene: View {
    @EnvironmentObject private var viewModel: AuthViewModel
    
    var body: some View {
        TabView {
            Tab("", systemImage: "house") {
                HomeView()
            }
            Tab("", systemImage: "person.circle") {
                ProfileView(viewModel: ProfileViewModel(authViewModel: viewModel))
            }
            Tab("", systemImage: "gear") {
                SettingsView()
            }
        }
    }
}

#Preview {
    TabScene()
}
