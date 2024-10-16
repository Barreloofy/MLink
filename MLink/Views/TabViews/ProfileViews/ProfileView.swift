//
//  ProfileView.swift
//  MLink
//
//  Created by Barreloofy on 10/6/24 at 12:02 AM.
//

import SwiftUI

struct ProfileView: View {
    @StateObject private var viewModel = ProfileViewModel()
    @EnvironmentObject private var userState: UserStateViewModel
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        NavigationStack {
            ZStack {
                Rectangle()
                    .fill(.ultraThickMaterial)
                    .opacity(0.25)
                    .ignoresSafeArea()
                ScrollView {
                    ImageView(imageData: viewModel.imageData)
                        .frame(width: 180, height: 180)
                        .clipShape(Circle())
                        .shadow(radius: 10)
                    Divider()
                        .frame(height: 3)
                        .background(Color.gray)
                        .padding(10)
                    Text(viewModel.username)
                        .font(.title)
                        .fontWeight(.heavy)
                    Text(viewModel.bioText)
                        .fontWeight(.medium)
                    Spacer()
                    LazyVStack {
                        ForEach(viewModel.userPosts) { post in
                            NavigationLink(value: post) {
                                PostView(post: post) { action in
                                    viewModel.actionProcess(action)
                                }
                            }
                        }
                    }
                }
                .tint(colorScheme == .light ? .black : .white)
                .navigationDestination(for: PostModel.self) { post in
                    PostDetailView(post: post)
                }
                if viewModel.isLoading {
                    LoadingView()
                }
                if viewModel.showAlert {
                    AlertView(isPresented: $viewModel.showAlert, message: viewModel.errorMessage)
                }
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
                    .sheet(isPresented: $viewModel.showEditPage) {
                        EditProfileView(viewModel: viewModel)
                    }
                }
            }
            .toolbarVisibility(viewModel.isLoading ? .hidden : .visible)
        }
        .onAppear {
            viewModel.loadData(for: userState.currentUser?.id)
            viewModel.LoadingTime()
        }
        .refreshable {
            viewModel.loadData(for: userState.currentUser?.id)
            viewModel.isLoading = false
        }
    }
}

#Preview {
    ProfileView()
        .environmentObject(UserStateViewModel())
}
