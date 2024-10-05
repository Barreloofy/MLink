//
//  ProfileView.swift
//  MLink
//
//  Created by Barreloofy on 10/6/24 at 12:02 AM.
//

import SwiftUI

struct ProfileView: View {
    @StateObject var viewModel: ProfileViewModel
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    ImageView(image: viewModel.image)
                        .frame(width: 180, height: 180)
                        .clipShape(Circle())
                        .shadow(radius: 10)
                    Divider()
                        .frame(height: 3)
                        .background(Color.gray)
                        .padding(10)
                    Text(viewModel.username)
                        .font(.headline)
                    Text(viewModel.bioText)
                        .fontWeight(.medium)
                    Spacer()
                }
                if viewModel.isLoading {
                    LoadingView()
                }
                if viewModel.showAlert {
                    AlertView(isPresented: $viewModel.showAlert, message: viewModel.errorMessage)
                }
            }
            .onAppear {
                viewModel.getImage()
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        viewModel.showEditPage.toggle()
                    } label: {
                        Text("Edit")
                            .fontWeight(.heavy)
                    }
                    .buttonStyle(SimpleButtonStyle())
                }
            }
            .sheet(isPresented: $viewModel.showEditPage) {
                EditProfileView(viewModel: viewModel)
            }
        }
    }
}
