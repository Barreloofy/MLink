//
//  ProfileView.swift
//  MLink
//
//  Created by Barreloofy on 10/4/24 at 2:44 PM.
//

import SwiftUI
import PhotosUI

struct EditProfileView: View {
    @ObservedObject var viewModel: ProfileViewModel
    
    var body: some View {
        ZStack {
            VStack {
                VStack {
                    ImageView(imageData: viewModel.imageData)
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                    PhotosPicker("Change Photo",selection: $viewModel.selectedItem, matching: .images)
                        .fontWeight(.heavy)
                        .buttonStyle(SimpleButtonStyle())
                        .onChange(of: viewModel.selectedItem) {
                            viewModel.loadImage()
                        }
                    TextField("Username", text: $viewModel.username)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                        .fontWeight(.medium)
                        .padding(10)
                        .onChange(of: viewModel.username) {
                            viewModel.enforceLength(for: &viewModel.username, maxLength: 30)
                        }
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
                            .onChange(of: viewModel.bioText) {
                                viewModel.enforceLength(for: &viewModel.bioText, maxLength: 52)
                            }
                    }
                    .scrollContentBackground(.hidden)
                    .frame(minHeight: 100, maxHeight: 100)
                    .padding(10)
                    Button {
                        viewModel.saveEdit()
                    } label: {
                        Text("Save")
                            .fontWeight(.heavy)
                    }
                    .buttonStyle(SimpleButtonStyle())
                    
                }
                .frame(width: 360, height: 390)
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .padding(25)
                Spacer()
            }
            if viewModel.showAlert {
                AlertView(isPresented: $viewModel.showAlert, message: viewModel.errorMessage)
            }
        }
    }
}

#Preview {
    EditProfileView(viewModel: ProfileViewModel())
}
