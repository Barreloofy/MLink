//
//  PostDetailView.swift
//  MLink
//
//  Created by Barreloofy on 10/13/24 at 4:14 PM.
//

import SwiftUI

struct PostDetailView: View {
    @Environment(\.dismiss) private var dismiss
    let post: PostModel
    var actionMessage: (ActionModel) -> Void
    @State private var postComments = [CommentModel]()
    
    var body: some View {
        ScrollView {
            PostView(viewModel: PostViewViewModel(post: post), actionMessage: actionMessage)
            Divider()
                .frame(height: 3)
                .background(Color.gray)
                .padding(10)
            CommentForm(post: post)
            LazyVStack {
                ForEach(postComments) { comment in
                    CommentView(comment: comment)
                }
            }
        }
        .background(.ultraThickMaterial.opacity(0.25))
        .navigationBarBackButtonHidden()
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
            Task {
                postComments = try await FirestoreService.fetchComments(for: post.id)
            }
        }
        .refreshable {
            Task {
                postComments = try await FirestoreService.fetchComments(for: post.id)
            }
        }
    }
}

#Preview {
    PostDetailView(post: PostModel.testPost) {_ in}
        .environmentObject(UserStateViewModel())
}
