//
//  ImageView.swift
//  MLink
//
//  Created by Barreloofy on 10/4/24 at 4:32 PM.
//

import SwiftUI

struct ImageView: View {
    let imageData: Data?
    
    var body: some View {
        if let imageData = imageData, let uiImage = UIImage(data: imageData) {
            Image(uiImage: uiImage)
                .resizable()
        } else {
            Image(systemName: "person.circle")
                .resizable()
        }
    }
}

#Preview {
    ImageView(imageData: nil)
}
