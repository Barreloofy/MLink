//
//  PostView.swift
//  MLink
//
//  Created by Barreloofy on 10/9/24 at 6:58 PM.
//

import SwiftUI

struct PostView: View {
    let post: PostModel
    
    var body: some View {
        VStack {
            HStack {
                Text(post.author)
                    .fontWeight(.heavy)
                Spacer()
                Text(post.timestampFormatter())
                    .font(.callout)
                    .fontWeight(.thin)
            }
            if let stringUrl = post.imageUrl, let imageUrl = URL(string: stringUrl) {
                AsyncImage(url: imageUrl) { image in
                    image
                        .resizable()
                        .scaledToFit()
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .shadow(radius: 10)
                        .padding()
                } placeholder: {
                    EmptyView()
                }
            }
            Text(post.text)
                .fontWeight(.medium)
            Spacer()
            HStack {
                Image(systemName: "heart")
                Image(systemName: "bubble")
                Spacer()
                Image(systemName: "trash")
            }
            .fontWeight(.bold)
        }
        .padding()
        .frame(width: 350)
        .frame(maxHeight: 623)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

#if DEBUG

#Preview {
    PostView(post: PostModel.testPost)
}

struct TestView: View {
    var body: some View {
        List(0..<10) {_ in
            PostView(post: PostModel.testPost)
                .listRowSeparator(.hidden)
        }
        .scrollContentBackground(.hidden)
    }
}

#Preview("TestView") {
    TestView()
}

#endif
