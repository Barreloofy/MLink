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
        ZStack {
            VStack {
                HStack {
                    Spacer()
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
                .padding()
                Spacer()
                if !viewModel.posts.isEmpty {
                    List(viewModel.posts) { post in
                        PostView(post: post, imageData: nil)
                            .listRowBackground(Color.clear)
                            .listRowSeparator(.hidden)
                    }
                    .scrollContentBackground(.hidden)
                } else {
                    Text("No post's yet")
                        .font(.title)
                        .fontWeight(.heavy)
                    Spacer()
                }
            }
            if viewModel.isLoading {
                LoadingView()
            }
            if viewModel.showAlert {
                AlertView(isPresented: $viewModel.showAlert, message: viewModel.errorMessage)
            }
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
}
