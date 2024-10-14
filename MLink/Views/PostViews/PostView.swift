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
                Button {} label: {
                    Image(systemName: "heart")
                }
                if post.likeCount > 0 {
                    Text("\(post.likeCount)")
                }
                Button {} label: {
                    Image(systemName: "bubble")
                }
                Spacer()
                Button {} label: {
                    Image(systemName: "trash")
                }
            }
        }
        .padding()
        .frame(width: 350)
        .frame(maxHeight: 623)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

#Preview {
    PostView(post: PostModel.testPost)
}
