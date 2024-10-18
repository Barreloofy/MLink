//
//  SignUpView.swift
//  MLink
//
//  Created by Barreloofy on 10/2/24 at 1:39 AM.
//

import SwiftUI

struct SignUpView: View {
    @EnvironmentObject private var viewModel: AuthenticationViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            VStack {
                Text("MLink")
                    .font(.largeTitle)
                    .fontWeight(.heavy)
                TextField("Username", text: $viewModel.username)
                    .roundedFieldStyle()
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                TextField("Email", text: $viewModel.email)
                    .roundedFieldStyle()
                    .textContentType(.emailAddress)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                SecureField("Password", text: $viewModel.password)
                    .roundedFieldStyle()
                Button {
                    viewModel.signUp()
                } label: {
                    Text("Sign Up")
                        .fontWeight(.heavy)
                }
                .buttonStyle(SimpleButtonStyle())
                Text("have an account already?")
                    .font(.caption)
                    .fontWeight(.light)
                Button {
                    dismiss()
                } label: {
                    Text("Sign In")
                        .fontWeight(.heavy)
                }
                .buttonStyle(SimpleButtonStyle())
            }
            .padding()
            .navigationBarBackButtonHidden()
            if viewModel.isLoading {
                LoadingView()
            }
            if viewModel.showAlert {
                AlertView(isPresented: $viewModel.showAlert, message: viewModel.errorMessage)
            }
        }
    }
}

#Preview {
    SignUpView()
        .environmentObject(AuthenticationViewModel())
}
