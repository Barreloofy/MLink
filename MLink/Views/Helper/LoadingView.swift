//
//  LoadingView.swift
//  MLink
//
//  Created by Barreloofy on 10/2/24 at 6:09 PM.
//

import SwiftUI

struct LoadingView: View {
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(.ultraThinMaterial)
                .ignoresSafeArea()
            ProgressView("loading...")
                .progressViewStyle(CircularProgressViewStyle())
                .padding()
                .fontWeight(.heavy)
                .foregroundStyle(colorScheme == .light ? .black : .white)
                .background(.ultraThickMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .shadow(radius: 5, x: 10, y: 10)
        }
    }
}

#Preview {
    LoadingView()
}
