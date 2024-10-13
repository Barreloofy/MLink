//
//  CommentForm.swift
//  MLink
//
//  Created by Barreloofy on 10/13/24 at 11:52 PM.
//

import SwiftUI

struct CommentForm: View {
    @StateObject private var viewModel = CommentFormViewModel()
    @EnvironmentObject private var userState: UserStateViewModel
    let post: PostModel
    
    var body: some View {
        VStack {
            ZStack {
                if viewModel.text.isEmpty {
                    TextEditor(text: .constant("Comment.."))
                        .opacity(0.25)
                }
                TextEditor(text: $viewModel.text)
                    .onChange(of: viewModel.text) {
                        if viewModel.text.count > 125 {
                            viewModel.text = String(viewModel.text.prefix(125))
                        }
                    }
            }
            .padding(5)
            .scrollContentBackground(.hidden)
            Button {
                viewModel.createComment(user: userState.currentUser, postId: post.id)
            } label: {
                Text("Comment")
                    .fontWeight(.heavy)
            }
            .padding(.bottom, 5)
            .buttonStyle(SimpleButtonStyle())
        }
        .background(.ultraThinMaterial)
        .frame(width: 340)
        .frame(minHeight: 85)
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

#Preview {
    CommentForm(post: PostModel.testPost)
}