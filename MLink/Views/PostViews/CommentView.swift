//
//  CommentView.swift
//  MLink
//
//  Created by Barreloofy on 10/13/24 at 4:38 PM.
//

import SwiftUI

struct CommentView: View {
    @EnvironmentObject private var userState: UserStateViewModel
    @StateObject private var viewModel = CommentViewViewModel()
    let comment: CommentModel
    var action: ((ActionType) -> Void)?
    
    var body: some View {
        
        VStack {
            
            HStack {
                Text(comment.author)
                Spacer()
                Text(comment.timestampFormatter())
                    .fontWeight(.light)
            }
            
            HStack {
                Text(comment.content)
                Spacer()
            }
            
            Spacer()
            
            HStack {
                
                Button {
                    viewModel.likeAction(comment: comment, userId: userState.currentUser?.id, action: action)
                } label: {
                    if viewModel.isLiked {
                        Image(systemName: "heart.fill")
                        .tint(.swiftOrange)
                    } else {
                        Image(systemName: "heart")
                    }
                }
                if comment.likeCount != 0 {
                    Text("\(comment.likeCount)")
                }
                
                Spacer()
                
                if comment.authorId == userState.currentUser?.id {
                    Button {
                        viewModel.showAlert = true
                    } label: {
                        Image(systemName: "trash")
                    }
                    .alert("Delete this comment?", isPresented: $viewModel.showAlert) {
                        Button("Cancel") {
                            viewModel.showAlert = false
                        }
                        Button("Delete") {
                            viewModel.deleteComment(for: comment, action: action)
                        }
                    }
                }
            }
        }
        .padding()
        .frame(maxWidth: 340, maxHeight: 191)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        
        .onAppear {
            viewModel.fetchIsLiked(comment: comment, userId: userState.currentUser?.id, action: action)
        }
    }
}

#Preview {
    CommentView(comment: CommentModel.testComment)
        .environmentObject(UserStateViewModel())
}
