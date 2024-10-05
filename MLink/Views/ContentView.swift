//
//  ContentView.swift
//  MLink
//
//  Created by Barreloofy on 10/2/24 at 12:27 AM.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = AuthViewModel()
    
    var body: some View {
        Group {
            if viewModel.currentUser != nil {
                TabScene()
            } else {
                AuthenticationView(viewModel: SignInViewModel(authViewModel: viewModel))
            }
        }
        .environmentObject(viewModel)
    }
}

#Preview {
    ContentView()
        .environmentObject(AuthViewModel())
}
