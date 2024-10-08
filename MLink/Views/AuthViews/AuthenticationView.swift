//
//  AuthenticationView.swift
//  MLink
//
//  Created by Barreloofy on 10/2/24 at 1:06 AM.
//

import SwiftUI

struct AuthenticationView: View {
    @StateObject private var viewModel = AuthenticationViewModel()
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    SignInView()
                    Text("no account yet?")
                        .font(.caption)
                        .fontWeight(.light)
                    NavigationLink {
                        SignUpView()
                    } label: {
                        Text("Sign Up")
                            .fontWeight(.heavy)
                            .foregroundStyle(.black)
                            .padding(5)
                            .background(
                                colorScheme == .light ? .gray.opacity(0.15) : .white
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 5))
                    }
                }
                .padding()
                if viewModel.isLoading {
                    LoadingView()
                }
                if viewModel.showAlert {
                    AlertView(isPresented: $viewModel.showAlert, message: viewModel.errorMessage)
                }
            }
        }
        .environmentObject(viewModel)
    }
}

#Preview {
    AuthenticationView()
}
