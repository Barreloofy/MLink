//
//  PostForm.swift
//  MLink
//
//  Created by Barreloofy on 10/6/24 at 5:24 PM.
//

import SwiftUI
import PhotosUI

struct PostForm: View {
    @StateObject private var viewModel = PostFormViewModel()
    @EnvironmentObject private var userState: UserStateViewModel
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(.ultraThickMaterial)
                .opacity(0.25)
                .ignoresSafeArea()
            VStack {
                HStack {
                    Text(userState.currentUser?.name ?? "Unknown User")
                        .font(.title)
                        .fontWeight(.heavy)
                        .padding(EdgeInsets(top: 5, leading: 20, bottom: 0, trailing: 0))
                    Spacer()
                }
                VStack {
                    PhotosPicker("Add Image", selection: $viewModel.selectedItem, matching: .images)
                        .fontWeight(.heavy)
                        .buttonStyle(SimpleButtonStyle())
                        .padding()
                        .onChange(of: viewModel.selectedItem) {
                            viewModel.loadImage()
                        }
                    if let imageData = viewModel.imageData, let uiImage = UIImage(data: imageData) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFit()
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .shadow(radius: 10)
                    }
                    ZStack {
                        if viewModel.text.isEmpty {
                            TextEditor(text: .constant("Compose..."))
                                .opacity(0.25)
                        }
                        TextEditor(text: $viewModel.text)
                            .scrollDisabled(true)
                            .fontWeight(.medium)
                            .onChange(of: viewModel.text) {
                                viewModel.enforceLength()
                            }
                    }
                    .scrollContentBackground(.hidden)
                    .padding()
                    HStack {
                        Text("\(viewModel.text.count)")
                            .fontWeight(.heavy)
                            .foregroundStyle(viewModel.indicatorColor)
                            .onChange(of: viewModel.text) {
                                viewModel.setIndicatorColor()
                            }
                        Spacer()
                    }
                    .padding(EdgeInsets(top: 0, leading: 20, bottom: 10, trailing: 0))
                }
                .frame(width: 360, height: 500)
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .padding(EdgeInsets(top: 0, leading: 20, bottom: 20, trailing: 20))
                Button {
                    viewModel.createPost(user: userState.currentUser)
                } label: {
                    Text("Save")
                        .fontWeight(.heavy)
                }
                .buttonStyle(SimpleButtonStyle())
                Spacer()
            }
            if viewModel.showAlert {
                AlertView(isPresented: $viewModel.showAlert, message: viewModel.errorMessage)
            }
        }
    }
}

#Preview {
    PostForm()
        .environmentObject(UserStateViewModel())
}
