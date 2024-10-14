//
//  URLImageView.swift
//  MLink
//
//  Created by Barreloofy on 10/14/24 at 5:31 PM.
//

import SwiftUI

struct URLImageView: View {
    let url: String?
    
    var body: some View {
        if let imageUrl = URL(string: url ?? "") {
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
    }
}

#Preview {
    URLImageView(url: "")
}
