//
//  SettingsView.swift
//  MLink
//
//  Created by Barreloofy on 10/3/24 at 10:24 PM.
//

import SwiftUI
import FirebaseAuth

struct SettingsView: View {
    @EnvironmentObject private var userState: UserStateViewModel
    @StateObject private var viewModel = SettingsViewModel()
    
    var body: some View {
        Button {
            userState.signOut()
        } label: {
            Text("Sign Out")
                .fontWeight(.heavy)
        }
        .buttonStyle(SimpleButtonStyle())
        Button("Delete Account") {
            viewModel.deleteAccount()
            userState.removeUserDataListener()
            userState.currentUser = nil
        }
    }
}

#Preview {
    SettingsView()
}
