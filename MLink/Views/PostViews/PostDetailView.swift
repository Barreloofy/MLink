//
//  PostDetailView.swift
//  MLink
//
//  Created by Barreloofy on 10/13/24 at 4:14 PM.
//

import SwiftUI

struct PostDetailView: View {
    @StateObject private var viewModel = PostDetailViewModel()
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.dismiss) private var dismiss
    let post: PostModel
    
    var body: some View {
        
        ZStack {
            ScrollView {
                PostView(post: post)
                Divider()
                    .frame(height: 3)
                    .background(Color.gray)
                    .padding(10)
                CommentForm(post: post) { action in
                    viewModel.actionProcess(action: action, postId: post.id)
                }
                LazyVStack {
                    ForEach(viewModel.comments) { comment in
                        CommentView(comment: comment) { action in
                            viewModel.actionProcess(action: action, postId: post.id)
                        }
                    }
                }
            }
            .foregroundStyle(colorScheme == .light ? .black : .white)
            .background(.ultraThickMaterial.opacity(0.25))
            .navigationBarBackButtonHidden()
            
            if viewModel.showAlert {
                AlertView(isPresented: $viewModel.showAlert, message: viewModel.errorMessage)
            }
        }
        
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "arrow.left")
                        .fontWeight(.heavy)
                }
            }
        }
        
        .onAppear {
            viewModel.fetchComments(for: post.id)
        }
        .refreshable {
            viewModel.fetchComments(for: post.id)
        }
    }
}

#Preview {
    PostDetailView(post: PostModel.testPost)
        .environmentObject(UserStateViewModel())
}
