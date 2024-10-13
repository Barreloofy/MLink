//
//  CommentView.swift
//  MLink
//
//  Created by Barreloofy on 10/13/24 at 4:38 PM.
//

import SwiftUI

struct CommentView: View {
    @EnvironmentObject private var userState: UserStateViewModel
    let comment: CommentModel
    
    var body: some View {
        VStack {
            HStack {
                Text(comment.author)
                Spacer()
                Text(comment.timestampFormatter())
            }
            HStack {
                Text(comment.content)
                Spacer()
            }
            Spacer()
            HStack {
                Image(systemName: "heart")
                Spacer()
                Image(systemName: "trash")
            }
        }
        .padding()
        .frame(maxWidth: 340, maxHeight: 191)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

#Preview {
    CommentView(comment: CommentModel.testComment)
        .environmentObject(UserStateViewModel())
}
