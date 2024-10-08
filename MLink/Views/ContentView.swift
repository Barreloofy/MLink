//
//  ContentView.swift
//  MLink
//
//  Created by Barreloofy on 10/2/24 at 12:27 AM.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = UserStateViewModel()
    @State private var isLaunching = true
    
    var body: some View {
        Group {
            if isLaunching {
                LaunchView()
                    .onAppear {
                        Task {
                            try await Task.sleep(nanoseconds: 1_000_000_000)
                            isLaunching = false
                        }
                    }
            } else {
                Group {
                    if viewModel.currentUser != nil {
                        TabScene()
                    } else {
                        AuthenticationView()
                    }
                }
                .environmentObject(viewModel)
            }
        }
        .animation(.easeInOut, value: isLaunching)
        .transition(.opacity)
    }
}

#Preview {
    ContentView()
        .environmentObject(UserStateViewModel())
}
