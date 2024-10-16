//
//  HomeView.swift
//  MLink
//
//  Created by Barreloofy on 10/4/24 at 2:40 PM.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        NavigationStack {
            ZStack {
                Rectangle()
                    .fill(.ultraThickMaterial)
                    .opacity(0.25)
                    .ignoresSafeArea()
                Group {
                    if viewModel.posts.isEmpty && viewModel.isLoading == false {
                        Text("No post's yet")
                            .font(.title)
                            .fontWeight(.heavy)
                    } else {
                        ScrollView {
                            LazyVStack {
                                ForEach(viewModel.posts) { post in
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
                    }
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
                        viewModel.showSheet.toggle()
                    } label: {
                        Text("Create Post")
                            .fontWeight(.heavy)
                    }
                    .buttonStyle(SimpleButtonStyle())
                    .sheet(isPresented: $viewModel.showSheet) {
                        PostForm() { action in
                            viewModel.actionProcess(action)
                        }
                    }
                }
            }
            .toolbarVisibility(viewModel.isLoading ? .hidden : .visible)
        }
        .onAppear {
            viewModel.fetchPostsOnAppear()
        }
        .refreshable {
            viewModel.refreshPosts()
        }
    }
}

#Preview {
    HomeView()
        .environmentObject(UserStateViewModel())
}
