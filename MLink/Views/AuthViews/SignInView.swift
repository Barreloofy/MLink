//
//  SignInView.swift
//  MLink
//
//  Created by Barreloofy on 10/2/24 at 1:12 AM.
//

import SwiftUI

struct SignInView: View {
    @EnvironmentObject private var viewModel: AuthenticationViewModel
    
    var body: some View {
        Text("MLink")
            .font(.largeTitle)
            .fontWeight(.heavy)
        TextField("Email", text: $viewModel.email)
            .roundedFieldStyle()
            .textContentType(.emailAddress)
            .textInputAutocapitalization(.never)
            .autocorrectionDisabled()
        SecureField("Password", text: $viewModel.password)
            .roundedFieldStyle()
        Button {
            viewModel.signIn()
        } label: {
            Text("Sign In")
                .fontWeight(.heavy)
        }
        .buttonStyle(SimpleButtonStyle())
    }
}

#Preview {
    SignInView()
}
