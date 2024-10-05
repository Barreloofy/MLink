//
//  SettingsView.swift
//  MLink
//
//  Created by Barreloofy on 10/3/24 at 10:24 PM.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject private var viewModel: AuthViewModel
    
    var body: some View {
        Button {
            viewModel.signOut()
        } label: {
            Text("Sign Out")
                .fontWeight(.heavy)
        }
        .buttonStyle(SimpleButtonStyle())
    }
}

#Preview {
    SettingsView()
}
