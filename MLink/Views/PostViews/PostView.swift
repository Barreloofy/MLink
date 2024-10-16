//
//  PostView.swift
//  MLink
//
//  Created by Barreloofy on 10/9/24 at 6:58 PM.
//

import SwiftUI

struct PostView: View {
    @EnvironmentObject private var userState: UserStateViewModel
    @StateObject private var viewModel = PostViewViewModel()
    let post: PostModel
    var action: ((ActionType) -> Void)?
    
    var body: some View {
        VStack {
            
            HStack {
                Text(post.author)
                    .fontWeight(.medium)
                Spacer()
                Text(post.timestampFormatter())
                    .fontWeight(.light)
            }
            
            URLImageView(url: post.imageUrl)
            
            HStack {
                Text(post.text)
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.leading)
                Spacer()
            }
            
            Spacer()
            
            HStack {
                
                Button {
                    viewModel.likeAction(post: post, userId: userState.currentUser?.id, action: action)
                } label: {
                    if viewModel.isLiked {
                        Image(systemName: "heart.fill")
                            .tint(.swiftOrange)
                    } else {
                        Image(systemName: "heart")
                    }
                }
                if post.likeCount > 0 {
                    Text("\(post.likeCount)")
                }
                
                Button {} label: {
                    Image(systemName: "bubble")
                }
                
                Spacer()
                
                if post.authorId == userState.currentUser?.id {
                    Button {
                        viewModel.showAlert = true
                    } label: {
                        Image(systemName: "trash")
                    }
                    .alert("Delete this post?", isPresented: $viewModel.showAlert) {
                        Button("Cancel") {
                            viewModel.showAlert = false
                        }
                        Button("Delete") {
                            viewModel.deletePost(for: post.id, action: action)
                        }
                    }
                }
            }
        }
        .padding()
        .frame(width: 350)
        .frame(maxHeight: 623)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        
        .onAppear {
            viewModel.fetchLikeStatus(post: post, userId: userState.currentUser?.id, action: action)
        }
    }
}

#Preview {
    PostView(post: PostModel.testPost)
        .environmentObject(UserStateViewModel())
}
