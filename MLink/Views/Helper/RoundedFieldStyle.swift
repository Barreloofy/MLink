//
//  RoundedFieldStyle.swift
//  MLink
//
//  Created by Barreloofy on 10/2/24 at 1:14 AM.
//

import SwiftUI

struct RoundedFieldStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .background(.gray.opacity(0.15))
            .clipShape(RoundedRectangle(cornerRadius: 15))
    }
}

extension View {
    func roundedFieldStyle() -> some View {
        self.modifier(RoundedFieldStyle())
    }
}
