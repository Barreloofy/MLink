//
//  PostView.swift
//  MLink
//
//  Created by Barreloofy on 10/9/24 at 6:58 PM.
//

import SwiftUI

struct PostView: View {
    let post: PostModel
    let imageData: Data?
    
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
            if let image = imageData, let uiImage = UIImage(data: image) {
                Image(uiImage: uiImage)
                    .resizable()
                    .frame(width: 300, height: 175)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .shadow(radius: 10)
                    .padding()
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
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

#if DEBUG

#Preview {
    PostView(post: PostModel.testPost, imageData: nil)
}

struct TestView: View {
    var body: some View {
        List(0..<10) {_ in
            PostView(post: PostModel.testPost, imageData: nil)
                .listRowSeparator(.hidden)
        }
        .scrollContentBackground(.hidden)
    }
}

#Preview("TestView") {
    TestView()
}

#endif
