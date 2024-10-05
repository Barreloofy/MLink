//
//  ImageView.swift
//  MLink
//
//  Created by Barreloofy on 10/4/24 at 4:32 PM.
//

import SwiftUI

struct ImageView: View {
    let image: UIImage?
    
    var body: some View {
        if let image = image {
            Image(uiImage: image)
                .resizable()
        } else {
            Image(systemName: "person.circle")
                .resizable()
        }
    }
}

#Preview {
    ImageView(image: nil)
}
