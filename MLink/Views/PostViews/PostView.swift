//
//  PostView.swift
//  MLink
//
//  Created by Barreloofy on 10/9/24 at 6:58 PM.
//

import SwiftUI

struct PostView: View {
    @StateObject var viewModel: PostViewViewModel
    @EnvironmentObject private var userState: UserStateViewModel
    @Environment(\.colorScheme) private var colorScheme
    var actionMessage: (ActionModel) -> Void
    
    var body: some View {
        VStack {
            HStack {
                Text(viewModel.post.author)
                    .fontWeight(.heavy)
                Spacer()
                Text(viewModel.post.timestampFormatter())
                    .font(.callout)
                    .fontWeight(.thin)
            }
            viewModel.loadImage(from: viewModel.post.imageUrl)
            HStack {
                Text(viewModel.post.text)
                    .fontWeight(.medium)
                    .multilineTextAlignment(.leading)
                Spacer()
            }
            Spacer()
            HStack {
                Button {
                    viewModel.likeAction(userId: userState.currentUser?.id)
                } label: {
                    Image(systemName: viewModel.isLiked ? "heart.fill" : "heart")
                        .tint(viewModel.isLiked ? .swiftOrange : colorScheme == .light ? .black : .white)
                }
                if viewModel.post.likeCount != 0 {
                    Text("\(viewModel.post.likeCount)")
                }
                Button {} label: {
                    Image(systemName: "bubble")
                }
                Spacer()
                if let uid = userState.currentUser?.id, uid == viewModel.post.authorId {
                    Button {
                        actionMessage(ActionModel(actionType: .delete, forItem: viewModel.post.id, fromUser: uid))
                    } label: {
                        Image(systemName: "trash")
                    }
                }
            }
            .buttonStyle(BorderlessButtonStyle())
            .fontWeight(.bold)
            .tint(colorScheme == .light ? .black : .white)
        }
        .padding()
        .frame(width: 350)
        .frame(maxHeight: 623)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .onAppear {
            viewModel.fetchLikeStatus(userId: userState.currentUser?.id, postId: viewModel.post.id)
        }
    }
}

#if DEBUG

#Preview {
    PostView(viewModel: PostViewViewModel(post: PostModel.testPost), actionMessage: {_ in})
        .environmentObject(UserStateViewModel())
}

struct TestView: View {
    var body: some View {
        List(0..<10) {_ in
            PostView(viewModel: PostViewViewModel(post: PostModel.testPost), actionMessage: {_ in})
                .listRowSeparator(.hidden)
        }
        .scrollContentBackground(.hidden)
    }
}

#Preview("TestView") {
    TestView()
        .environmentObject(UserStateViewModel())
}

#endif
