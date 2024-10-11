//
//  HomeView.swift
//  MLink
//
//  Created by Barreloofy on 10/4/24 at 2:40 PM.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack {
                Rectangle()
                    .fill(.ultraThickMaterial)
                    .opacity(0.25)
                    .ignoresSafeArea()
                Group {
                    if viewModel.posts.isEmpty {
                        Text("No post's yet")
                            .font(.title)
                            .fontWeight(.heavy)
                    } else {
                        ScrollView {
                            LazyVStack {
                                ForEach(viewModel.posts) { post in
                                    PostView(post: post)
                                }
                            }
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
                        PostForm()
                    }
                }
            }
            .toolbarVisibility(viewModel.isLoading ? .hidden : .visible)
        }
        .onAppear {
            viewModel.fetchAllPosts(refreshable: false)
        }
        .refreshable {
            viewModel.fetchAllPosts(refreshable: true)
        }
    }
}

#Preview {
    HomeView()
        .environmentObject(UserStateViewModel())
}
