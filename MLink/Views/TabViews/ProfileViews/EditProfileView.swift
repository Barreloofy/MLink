//
//  ProfileView.swift
//  MLink
//
//  Created by Barreloofy on 10/4/24 at 2:44 PM.
//

import SwiftUI
import PhotosUI

struct EditProfileView: View {
    @StateObject var viewModel: ProfileViewModel
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(.ultraThinMaterial)
                .ignoresSafeArea()
            VStack {
                VStack {
                    ImageView(image: viewModel.image)
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                    PhotosPicker("Change Photot",selection: $viewModel.imageSelection, matching: .images)
                        .buttonStyle(SimpleButtonStyle())
                    TextField("Username", text: $viewModel.username)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                        .fontWeight(.medium)
                        .padding(.leading, 5)
                    Divider()
                        .padding(5)
                    ZStack {
                        if viewModel.bioText.isEmpty {
                            TextEditor(text: .constant("Bio..."))
                                .opacity(0.25)
                                .fontWeight(.medium)
                        }
                        TextEditor(text: $viewModel.bioText)
                            .fontWeight(.medium)
                    }
                    .scrollContentBackground(.hidden)
                    .frame(minHeight: 100, maxHeight: 100)
                    .padding(.bottom, 5)
                    Button {
                        viewModel.updateUser()
                        viewModel.showEditPage.toggle()
                    } label: {
                        Text("Save")
                            .fontWeight(.heavy)
                    }
                    .buttonStyle(SimpleButtonStyle())
                    
                }
                .frame(width: 360, height: 360)
                .background(.ultraThickMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                Spacer()
            }
            if viewModel.showAlert {
                AlertView(isPresented: $viewModel.showAlert, message: viewModel.errorMessage)
            }
        }
    }
}

#Preview {
    EditProfileView(viewModel: ProfileViewModel(authViewModel: AuthViewModel()))
}
