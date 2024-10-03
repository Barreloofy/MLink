//
//  SimpleButtonStyle.swift
//  MLink
//
//  Created by Barreloofy on 10/2/24 at 2:08 AM.
//

import SwiftUI

struct SimpleButtonStyle: ButtonStyle {
    @Environment(\.colorScheme) private var colorScheme
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(5)
            .foregroundStyle(.black)
            .background(colorScheme == .light ? .gray.opacity(0.15) : .white)
            .clipShape(RoundedRectangle(cornerRadius: 5))
            .scaleEffect(configuration.isPressed ? 1.10 : 1.00)
    }
}
